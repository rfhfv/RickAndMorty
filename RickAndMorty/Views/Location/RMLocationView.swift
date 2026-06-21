import UIKit

protocol RMLocationViewDelegate: AnyObject {
    func rmLocaionView(_ locationView: RMLocationView, didSelect location: RMLocation)
}

final class RMLocationView: UIView {
    
    private var viewModel: RMLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
            
            viewModel?.registerDidFinishPaginationBlock { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(RMLocationViewTableViewCell.self, forCellReuseIdentifier: RMLocationViewTableViewCell.cellidentifier)
        table.alpha = 0
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    public weak var delegate: RMLocationViewDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: RMLocationViewViewModel) {
        self.viewModel = viewModel
    }
}

private extension RMLocationView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, spinner)
        spinner.startAnimating()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UITableView

extension RMLocationView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.indices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else {
            fatalError()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationViewTableViewCell.cellidentifier, for: indexPath) as? RMLocationViewTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = cellViewModels[indexPath.row]
        cell.cofigure(with: cellViewModel)
        return cell
    }
}

extension RMLocationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let locationModel = viewModel?.location(at: indexPath.row) else {
            return
        }
        delegate?.rmLocaionView(self, didSelect: locationModel)
    }
}

// MARK: - UIScrollViewDelegate

extension RMLocationView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !viewModel.cellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreLocations else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.showLoadingIndicator()
                viewModel.fetchAdditionalLocations()
            }
            t.invalidate()
        }
    }
    
    private func showLoadingIndicator() {
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView  = footer
    }
}

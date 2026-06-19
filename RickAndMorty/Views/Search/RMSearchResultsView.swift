import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

final class RMSearchResultsView: UIView {
    
    weak var delegate: RMSearchResultsViewDelegate?
    
    private var locationCellViewModel: [RMLocationViewTableViewCellViewModel] = []
    private var collectionViewCellViewModels: [any Hashable] = []
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationViewTableViewCell.self, forCellReuseIdentifier: RMLocationViewTableViewCell.cellidentifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

private extension RMSearchResultsView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        switch viewModel {
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setupCollectionView()
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setupCollectionView()
        case .locations(let viewModels):
            setupTableView(viewModels: viewModels)
        }
    }
    
    func setupCollectionView() {
        self.collectionView.isHidden = false
        self.tableView.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
    }
    
    func setupTableView(viewModels: [RMLocationViewTableViewCellViewModel]) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = false
        self.locationCellViewModel = viewModels
        tableView.reloadData()
    }
    
    func setupViews() {
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - TableView

extension RMSearchResultsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationViewTableViewCell.cellidentifier, for: indexPath) as? RMLocationViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.cofigure(with: locationCellViewModel[indexPath.row])
        return cell
    }
}

extension RMSearchResultsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - CollectionView

extension RMSearchResultsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterVM =  currentViewModel as? RMCharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: characterVM)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }
}

extension RMSearchResultsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension RMSearchResultsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        let bounts = collectionView.bounds
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            let width = (bounts.width - 30) / 2
            return CGSize(
                width: width,
                height: width * 1.5
            )
        }
        
        let width = (bounts.width - 20)
        return CGSize(
            width: width,
            height: 100
        )
    }
}

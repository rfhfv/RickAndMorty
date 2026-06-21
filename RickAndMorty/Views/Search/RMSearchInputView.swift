import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didSlectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didChangesearchText text: String)
    func rmSearchInputViewDidtapSearchKeybosrdButton(_ inputView: RMSearchInputView)
}

final class RMSearchInputView: UIView {
    
    private var stackView: UIStackView?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    
    weak var delegate: RMSearchInputViewDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    public func presentkKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String) {
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option) else {
            return
        }
        
        buttons[index].setAttributedTitle(
            NSAttributedString(
                string:  value.uppercased(),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.link
                ]
            ), for: .normal
        )
    }
}

// MARK: - Private

private extension RMSearchInputView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) {
        let stackView = createOptionStackView()
        self.stackView = stackView
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    func createButton(
        with option: RMSearchInputViewViewModel.DynamicOption,
        tag: Int) -> UIButton {
            let button = UIButton()
            button.setAttributedTitle(
                NSAttributedString(
                    string: option.rawValue,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                        .foregroundColor: UIColor.label
                    ]
                ), for: .normal
            )
            button.backgroundColor = .secondarySystemBackground
            button.tag = tag
            button.layer.cornerRadius = 6
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            return button
        }
    
    func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        return stackView
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else {
            return
        }
        
        let tag = sender.tag
        let selected = options[tag]
        delegate?.rmSearchInputView(self, didSlectOption: selected)
    }
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        searchBar.delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}

// MARK: - UISearchBarDelegate

extension RMSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangesearchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidtapSearchKeybosrdButton(self)
    }
}

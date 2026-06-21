import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter)
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode)
}

class RMSearchView: UIView {
    
    private let viewModel: RMSearchViewViewModel
    private let searchInputView = RMSearchInputView()
    private let noResultsview = RMNoSearchResultsView()
    private let resultsView = RMSearchResultsView()
    
    weak var delegate: RMSearchViewDelegate?
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setupHandlers(viewModel: viewModel)
        
        resultsView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func presentkKeyboard() {
        searchInputView.presentkKeyboard()
    }
}

private extension RMSearchView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noResultsview.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultHandler {
            DispatchQueue.main.async { [weak self] in
                self?.noResultsview.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    func setupViews() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsview, searchInputView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 120),
            
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noResultsview.heightAnchor.constraint(equalToConstant: 150),
            noResultsview.widthAnchor.constraint(equalToConstant: 150),
            noResultsview.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultsview.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: - CollectionView

extension RMSearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension RMSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - RMSearchInputViewDelegate

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSlectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangesearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidtapSearchKeybosrdButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

// MARK: - RMSearchResultsViewDelegate

extension RMSearchView: RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectEpisode: episodeModel)
    }
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectCharacter: characterModel)
    }
}

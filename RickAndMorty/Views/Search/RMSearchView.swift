import UIKit

class RMSearchView: UIView {
    
    private let viewModel: RMSearchViewViewModel
    
    private let noResultsview = RMNoSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RMSearchView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsview)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            noResultsview.heightAnchor.constraint(equalToConstant: 150),
            noResultsview.widthAnchor.constraint(equalToConstant: 150),
            noResultsview.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultsview.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: - CollectionView Delegates

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

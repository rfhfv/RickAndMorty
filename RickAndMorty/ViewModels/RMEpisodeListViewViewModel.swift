import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitalEpisodes()
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

final class RMEpisodeListViewViewModel: NSObject {
    
    private var isLoadingMoreEpisodes = false
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemMint,
        .systemIndigo
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            createCellViewModels()
        }
    }
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public func fetchEpisodes() {
        RMService.shared.execute(
            .listEpisodesRequests,
            expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info
                    self.episodes = results
                    self.apiInfo = info
                    DispatchQueue.main.async {
                        self.delegate?.didLoadInitalEpisodes()
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }
    
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreEpisodes else {
            return
        }
        
        isLoadingMoreEpisodes = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.apiInfo = info
                    
                    let originalCount = self.episodes.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    
                    self.episodes.append(contentsOf: moreResults)
                    
                    DispatchQueue.main.async {
                        self.delegate?.didLoadMoreEpisodes(with: indexPathToAdd
                        )
                        self.isLoadingMoreEpisodes = false
                    }
                case .failure(let error):
                    print(String(describing: error))
                    self.isLoadingMoreEpisodes = false
                }
            }
    }
    
    private func createCellViewModels() {
        for episode in episodes {
            let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                episodeDataUrl: URL(string: episode.url),
                borderColor: borderColors.randomElement() ?? .systemBlue
            )
            
            if !cellViewModels.contains(viewModel) {
                cellViewModels.append(viewModel)
            }
        }
    }
}

// MARK: - CollectionView

extension RMEpisodeListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: cellViewModels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension RMEpisodeListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounts = collectionView.bounds
        let width = (bounts.width - 20)
        return CGSize(
            width: width,
            height: 100
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

// MARK: - ScrollView

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            shouldShowLoadMoreIndicator,
            !isLoadingMoreEpisodes,
            !cellViewModels.isEmpty,
            let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString)
        else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}

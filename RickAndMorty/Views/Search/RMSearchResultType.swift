import Foundation

final class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    private var next: String?
    
    public private(set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationViewTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllLocationsReponse.self) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.next = info.next
                    
                    let additionLocations =  moreResults.compactMap({
                        return RMLocationViewTableViewCellViewModel(location: $0)
                    })
                    
                    var newResults: [RMLocationViewTableViewCellViewModel] = []
                    switch self.results {
                    case .locations(let existingResults):
                        newResults = existingResults + additionLocations
                        self.results = .locations(newResults)
                    case .characters, .episodes:
                        break
                    }
                    
                    DispatchQueue.main.async {
                        self.isLoadingMoreResults = false
                        completion(newResults)
                    }
                case .failure(let error):
                    print(String(describing: error))
                    self.isLoadingMoreResults = false
                }
            }
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(
                request,
                expecting: RMGetAllCharactesResponse.self) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let responseModel):
                        let moreResults = responseModel.results
                        let info = responseModel.info
                        self.next = info.next
                        
                        let additionResults =  moreResults.compactMap({
                            return RMCharacterCollectionViewCellViewModel(
                                characterName: $0.name,
                                characterStatus: $0.status,
                                characterImageUrl: URL(string: $0.image)
                            )
                        })
                        
                        var newResults: [RMCharacterCollectionViewCellViewModel] = []
                        newResults = existingResults + additionResults
                        self.results = .characters(newResults)
                        
                        DispatchQueue.main.async {
                            self.isLoadingMoreResults = false
                            completion(newResults)
                        }
                    case .failure(let error):
                        print(String(describing: error))
                        self.isLoadingMoreResults = false
                    }
                }
        case .episodes(let existingResults):
            RMService.shared.execute(
                request,
                expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let responseModel):
                        let moreResults = responseModel.results
                        let info = responseModel.info
                        self.next = info.next
                        
                        let additionResults =  moreResults.compactMap({
                            return RMCharacterEpisodeCollectionViewCellViewModel(
                                episodeDataUrl: URL(string: $0.url))
                        })
                        
                        var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                        newResults = existingResults + additionResults
                        self.results = .episodes(newResults)
                        
                        DispatchQueue.main.async {
                            self.isLoadingMoreResults = false
                            completion(newResults)
                        }
                    case .failure(let error):
                        print(String(describing: error))
                        self.isLoadingMoreResults = false
                    }
                }
        case .locations:
            break
        }
    }
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationViewTableViewCellViewModel])
}

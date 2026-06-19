import Foundation

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    // MARK: - Init
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    public func executeSearch() {
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
        
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsReponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.proccessSearchResults(model: model)
            case .failure:
                break
            }
        }
    }
    
    private func proccessSearchResults(model: Codable) {
        var resultsVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactesResponse {
            print("Results: \(characterResults.results)")
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
        }
        else if let episodesResults = model as? RMGetAllEpisodesResponse {
            print("Results: \(episodesResults.results)")
            resultsVM = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )
            }))
        }
        else if let locationsResults = model as? RMGetAllLocationsReponse {
            print("Results: \(locationsResults.results)")
            resultsVM = .locations(locationsResults.results.compactMap({
                return RMLocationViewTableViewCellViewModel(
                    location: $0
                )
            }))
        }
        
        if let results = resultsVM {
            self.searchResultHandler?(results)
        }
        else {
            // Error
        }
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }
}

import Foundation

protocol RMLocationViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations: Bool = false
    
    public private(set) var cellViewModels: [RMLocationViewTableViewCellViewModel] = []
    
    weak var delegate: RMLocationViewModelDelegate?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationViewTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
                
            }
        }
    }
    
    private var apiInfo: RMGetAllLocationsReponse.Info?
    
    // MARK: - Init
    
    init() {}
    
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreLocations = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
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
                    self.apiInfo = info
                    self.cellViewModels.append(contentsOf: moreResults.compactMap({
                        return RMLocationViewTableViewCellViewModel(location: $0)
                    }))
                    
                    DispatchQueue.main.async {
                        self.isLoadingMoreLocations = false
                    }
                case .failure(let error):
                    print(String(describing: error))
                    self.isLoadingMoreLocations = false
                }
            }
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(
            .listLocationsRequests,
            expecting: RMGetAllLocationsReponse.self
        ) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}

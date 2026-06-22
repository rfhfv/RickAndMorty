import Foundation

protocol RMLocationViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    private var apiInfo: RMGetAllLocationsReponse.Info?
    private var didFinishPagination: (() -> Void)?
    
    private var hasMoreResults: Bool { false }
    
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
    
    weak var delegate: RMLocationViewModelDelegate?
    
    public var isLoadingMoreLocations = false
    public private(set) var cellViewModels: [RMLocationViewTableViewCellViewModel] = []
    
    public var shouldShowLoadMoreIndicator: Bool { apiInfo?.next != nil }
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Public
    
    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
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
    
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString),
              let request = RMRequest(url: url) else { return }
        
        isLoadingMoreLocations = true
        
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
                        self.didFinishPagination?()
                    }
                case .failure(let error):
                    print(String(describing: error))
                    self.isLoadingMoreLocations = false
                }
            }
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard locations.indices.contains(index) else  { return nil }
        return self.locations[index]
    }
}

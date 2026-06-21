import Foundation

struct RMLocationViewTableViewCellViewModel: Hashable, Equatable {
    
    private let location: RMLocation
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type" + location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
    
    init(location: RMLocation) {
        self.location = location
    }
    
    static func == (lhs: RMLocationViewTableViewCellViewModel, rhs: RMLocationViewTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}

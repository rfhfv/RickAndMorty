import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
            switch self {
            case .status: return .systemBlue
            case .gender: return .systemRed
            case .type: return .systemPurple
            case .species: return .systemGreen
            case .origin: return .systemOrange
            case .created: return .systemPink
            case .location: return .systemYellow
            case .episodeCount: return .systemMint
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status: return rawValue
            case .gender: return rawValue
            case .type: return rawValue
            case .species: return rawValue
            case .origin: return rawValue
            case .created: return rawValue
            case .location: return rawValue
            case .episodeCount: return "Episode count"
            }
        }
    }
    
    private let type: `Type`
    private let value: String
    
    private var characterStatus: RMCharacterStatus = .unknown
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    public var characterBackgroundColor: UIColor { characterStatus.backgroudColor }
    public var characterTextColor: UIColor { characterStatus.textColor }
    
    public var title: String {
        self.type.displayTitle.uppercased()
    }
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
        
        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        
        return value
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    
    init(
        type: `Type`,
        value: String
    ) {
        self.value = value
        self.type = type
    }
}

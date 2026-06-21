import UIKit

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
    
    var backgroudColor: UIColor {
        switch self {
        case .alive:   return .cmGreen
        case .dead:    return .cmRed
        case .unknown: return .cmYellow
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .alive:   return .cmDarkGreen
        case .dead:    return .cmDarkRed
        case .unknown: return .cmDarkYellow
        }
    }
}

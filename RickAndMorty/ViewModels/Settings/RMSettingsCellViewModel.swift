import UIKit

struct RMSettingsCellViewModel: Identifiable {
    
    public let id = UUID()
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainterColor
    }
    
    // MARK: - Init
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}

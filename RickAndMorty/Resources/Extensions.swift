import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

extension UIColor {
    static var cmGreen: UIColor { UIColor(named: "CM Green") ?? UIColor.systemGreen }
    static var cmRed: UIColor { UIColor(named: "CM Red") ?? UIColor.systemRed }
    static var cmYellow: UIColor { UIColor(named: "CM Yellow") ?? UIColor.systemYellow }
    
    static var cmDarkGreen: UIColor { UIColor(named: "CM Dark Green") ?? UIColor.systemGreen }
    static var cmDarkRed: UIColor { UIColor(named: "CM Dark Red") ?? UIColor.systemRed }
    static var cmDarkYellow: UIColor { UIColor(named: "CM Dark Yellow") ?? UIColor.systemYellow }
}

extension UIDevice {
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}


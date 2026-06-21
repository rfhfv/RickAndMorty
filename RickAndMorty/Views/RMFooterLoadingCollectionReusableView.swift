import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    
    static let identifier = String(describing: RMFooterLoadingCollectionReusableView.self)
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
}

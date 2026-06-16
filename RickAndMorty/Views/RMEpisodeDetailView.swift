import UIKit

final class RMEpisodeDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RMEpisodeDetailView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}


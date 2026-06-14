import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: RMCharacterEpisodeCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
    }
}

private extension RMCharacterEpisodeCollectionViewCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
}


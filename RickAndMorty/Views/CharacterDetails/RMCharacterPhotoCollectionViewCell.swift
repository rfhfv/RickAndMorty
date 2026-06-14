import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: RMCharacterPhotoCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
    }
}

private extension RMCharacterPhotoCollectionViewCell {
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


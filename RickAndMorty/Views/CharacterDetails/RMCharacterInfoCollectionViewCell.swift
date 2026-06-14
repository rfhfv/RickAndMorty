import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: RMCharacterInfoCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
    }
}

private extension RMCharacterInfoCollectionViewCell {
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


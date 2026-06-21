import UIKit

final class RMCharacterCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: RMCharacterCollectionViewCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.setupLayer()
        }
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        statusLabel.backgroundColor = viewModel.characterColor
        
        viewModel.fetchImage { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let image = UIImage(data: data)
                    self.imageView.image = image
                }
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    print("USED DEFAULT IMAGE")
                    let image = UIImage(named: "DefaultImage")
                    self.imageView.image = image
                }
                break
            }
        }
    }
}

private extension RMCharacterCollectionViewCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLabel, statusLabel)
    }
    
    func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 36),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10),
        ])
    }
}

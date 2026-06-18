import UIKit

final class RMLocationViewTableViewCell: UITableViewCell {
    static let cellidentifier = String(describing: RMLocationViewTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func cofigure(with viewModel: RMLocationViewTableViewCellViewModel) {
        
    }
}

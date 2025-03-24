
import UIKit

final class StargazersTableViewCell: UITableViewCell {
    
    static let identifier = "StargazerCell"
    
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func configure(with stargazer: Stargazer, image: UIImage) {
        usernameLabel.text = stargazer.login
        avatarImageView.image = image
    }
    
    override func prepareForReuse() {
        avatarImageView.image = nil
        usernameLabel.text = nil
    }
}

//MARK: - UI Setup
private extension StargazersTableViewCell {
    
    func setupViews() {
        setupAvatarImageView()
        setupUsernameLabel()
    }
    
    func setupAvatarImageView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        contentView.addSubview(avatarImageView)
    }
    
    func setupUsernameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(usernameLabel)
    }
    
    //MARK: Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

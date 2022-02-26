import UIKit

class HandPoseCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    lazy var handPoseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.defaultLabel(config: UILabel.Config(
            title: "",
            textColor: activeTheme.colors.blank,
            textAlignment: .center,
            font: activeTheme.fonts.handPoseLabel
        ))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // MARK: - Variables
    let topBottomContentViewDistance: CGFloat = 34
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
        setupHandPoseImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupHandPoseImageView() {
        addSubview(handPoseImageView)
        handPoseImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handPoseImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -10),
            handPoseImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            handPoseImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            handPoseImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10)
        ])
    }
}

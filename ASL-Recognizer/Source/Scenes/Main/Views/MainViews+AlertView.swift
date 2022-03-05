import UIKit
import AVFoundation

extension MainViews {
    class AlertView: UIView {
        // MARK: - Views
        private lazy var backgroundView: UIView = {
            let view = UIView()
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            return view
        }()
        
        private lazy var alertImageView: UIImageView = UIImageView.defaultImageView(
            config: UIImageView.Config(image: UIImage())
        )
        
        private lazy var alertTitleLabel: UILabel = UILabel.defaultLabel(
            config: UILabel.Config(
                title: "",
                textColor: activeTheme.colors.blank,
                textAlignment: .center
            )
        )
        
        // MARK: - Variables
        private var detectActionHandler: (() -> Void)?

        // MARK: - Life Cycle
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Setup
        func setupDetectActionHandler(_ handler: @escaping () -> Void) {
            detectActionHandler = handler
        }
        
        private func setupViews() {
            backgroundColor = .clear
            setupBackgroundView()
            setupAlertTitleLabel()
            setupAlertImageView()
        }
        
        private func setupBackgroundView() {
            addSubview(backgroundView)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        
        private func setupAlertTitleLabel() {
            addSubview(alertTitleLabel)
            alertTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                alertTitleLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 5),
                alertTitleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 40
                ),
                alertTitleLabel.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -40
                ),
                alertTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
            ])
        }
        
        private func setupAlertImageView() {
            addSubview(alertImageView)
            alertImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                alertImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -5),
                alertImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                alertImageView.widthAnchor.constraint(equalToConstant: 50),
                alertImageView.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        func updateAlertView(image: UIImage, title: String) {
            alertImageView.image = image
            alertTitleLabel.text = title
        }
    }
}

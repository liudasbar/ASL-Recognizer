import UIKit
import AVFoundation

extension MainViews {
    class InfoView: UIView {
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
        
        private lazy var infoButton: UIButton = {
            let button = UIButton()
            updateStatusButton(
                button: button,
                imageName: "info.circle",
                interaction: true
            )
            button.tintColor = activeTheme.colors.buttonDefault
            button.addTarget(self, action: #selector(infoAction), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Variables
        private let imageConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .light, scale: .default)
        private var infoActionHandler: (() -> Void)?

        // MARK: - Life Cycle
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Setup
        func setupInfoActionHandler(_ handler: @escaping () -> Void) {
            infoActionHandler = handler
        }
        
        private func setupViews() {
            backgroundColor = .clear
            setupBackgroundView()
            setupInfoButton()
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
        
        private func setupInfoButton() {
            addSubview(infoButton)
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                infoButton.topAnchor.constraint(equalTo: self.topAnchor),
                infoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                infoButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        // MARK: - Actions
        @objc func infoAction() {
            infoActionHandler?()
        }
        
        private func updateStatusButton(button: UIButton, imageName: String, interaction: Bool) {
            let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
            button.setImage(image, for: .normal)
            button.isUserInteractionEnabled = interaction
        }
    }
}

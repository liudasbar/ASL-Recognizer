import UIKit
import AVFoundation

extension MainViews {
    class DetectStatusView: UIView {
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
        
        private lazy var startDetectionButton: UIButton = {
            let button = UIButton()
            updateStatusButton(
                button: button,
                imageName: "viewfinder.circle",
                stringValue: L10n.Main.Button.startDetection,
                interaction: true
            )
            button.tintColor = activeTheme.colors.blank
            button.addTarget(self, action: #selector(startDetectionAction), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Variables
        private let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light, scale: .default)
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
            setupStartDetectionButton()
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
        
        private func setupStartDetectionButton() {
            addSubview(startDetectionButton)
            startDetectionButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                startDetectionButton.topAnchor.constraint(equalTo: self.topAnchor),
                startDetectionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                startDetectionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
                startDetectionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        // MARK: - Actions
        @objc func startDetectionAction() {
            updateStatusButton(
                button: startDetectionButton,
                imageName: "viewfinder.circle.fill",
                stringValue: L10n.Main.Button.detecting,
                interaction: false
            )
            mainAsyncAfter(deadline: .now() + 0.5, execute: {
                self.detectActionHandler?()
                self.updateStatusButton(
                    button: self.startDetectionButton,
                    imageName: "viewfinder.circle",
                    stringValue: L10n.Main.Button.startDetection,
                    interaction: true
                )
            })
        }
        
        private func updateStatusButton(button: UIButton, imageName: String, stringValue: String, interaction: Bool) {
            let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
            button.setTitle("  " + stringValue, for: .normal)
            button.setImage(image, for: .normal)
            button.isUserInteractionEnabled = interaction
        }
    }
}

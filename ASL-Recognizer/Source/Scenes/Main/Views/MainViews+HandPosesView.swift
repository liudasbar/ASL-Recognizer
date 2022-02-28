import UIKit
import AVFoundation

extension MainViews {
    class HandPosesView: UIView {
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
        
        private lazy var handPosesButton: UIButton = {
            let button = UIButton()
            button.setTitle("  " + L10n.Main.Button.handPoses, for: .normal)
            button.setImage(UIImage(systemName: "hand.point.up.left.fill"), for: .normal)
            button.tintColor = activeTheme.colors.buttonDefault
            button.setTitleColor(activeTheme.colors.buttonDefault, for: .normal)
            button.setTitleColor(activeTheme.colors.buttonDefault.withAlphaComponent(0.4), for: .highlighted)
            button.addTarget(self, action: #selector(openHandPosesAction), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Variables
        private let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light, scale: .default)
        private var openHandPosesActionHandler: (() -> Void)?

        // MARK: - Life Cycle
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Setup
        func setupOpenHandPosesActionHandler(_ handler: @escaping () -> Void) {
            openHandPosesActionHandler = handler
        }
        
        private func setupViews() {
            backgroundColor = .clear
            setupBackgroundView()
            setupHandPosesButton()
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
        
        private func setupHandPosesButton() {
            addSubview(handPosesButton)
            handPosesButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                handPosesButton.topAnchor.constraint(equalTo: self.topAnchor),
                handPosesButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                handPosesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
                handPosesButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        // MARK: - Actions
        @objc func openHandPosesAction() {
            openHandPosesActionHandler?()
        }
    }
}

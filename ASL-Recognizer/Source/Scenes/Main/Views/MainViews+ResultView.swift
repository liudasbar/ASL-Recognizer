import UIKit
import AVFoundation

extension MainViews {
    class ResultView: UIView {
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
        private lazy var resultLabel: UILabel = {
            let label = UILabel.defaultLabel(config: UILabel.Config(
                title: "HELLO HOW ARE YOU MOMMY HELLO HOW ARE YOU MOMMY",
                textColor: activeTheme.colors.blank,
                textAlignment: .center,
                font: activeTheme.fonts.resultLabel
            ))
            return label
        }()
        private lazy var clearResultButton: UIButton = {
            let button = UIButton()
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)
            let image = UIImage(systemName: "delete.backward", withConfiguration: imageConfig)
            button.setImage(image, for: .normal)
            button.tintColor = activeTheme.colors.blank
            button.addTarget(self, action: #selector(clearResultAction), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Variables
        private var clearResultButtonHandler: (() -> Void)?

        // MARK: - Life Cycle
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Setup
        private func setupViews() {
            backgroundColor = .clear
            setupBackgroundView()
            setupClearResultButton()
            setupResultLabel()
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
        
        private func setupClearResultButton() {
            addSubview(clearResultButton)
            clearResultButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                clearResultButton.topAnchor.constraint(equalTo: self.topAnchor),
                clearResultButton.widthAnchor.constraint(equalToConstant: 60),
                clearResultButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                clearResultButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        private func setupResultLabel() {
            addSubview(resultLabel)
            resultLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                resultLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                resultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                resultLabel.trailingAnchor.constraint(equalTo: clearResultButton.leadingAnchor),
                resultLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
        }
        
        func setupClearResultButtonHandler(_ handler: @escaping () -> Void) {
            clearResultButtonHandler = handler
        }
        
        // MARK: - Actions
        @objc private func clearResultAction() {
            resultLabel.text?.removeAll()
            clearResultButtonHandler?()
        }
    }
}

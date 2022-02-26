import UIKit

extension HandPosesViews {
    class RootView: UIView {
        // MARK: - Views
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Hello World!"
            label.textColor = .red
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        private lazy var startButton: UIButton = {
            let button = UIButton()
            button.setTitle("START", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Variables
        private var startButtonHandler: (() -> Void)?

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
            backgroundColor = .white
            setupTitleLabel()
            setupStartButton()
        }
        
        private func setupTitleLabel() {
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
        private func setupStartButton() {
            addSubview(startButton)
            NSLayoutConstraint.activate([
                startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                startButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
        func setupStartButtonHandler(_ handler: @escaping () -> Void) {
            startButtonHandler = handler
        }

        // MARK: - Populate
        func populate(_ viewModel: HandPoses.LoadGreeting.ViewModel) {
            guard case let .greeting(text) = viewModel else {
                return
            }
            titleLabel.text = text
        }
        
        // MARK: - Actions
        @objc private func startButtonAction() {
            startButtonHandler?()
        }
        
    }
}

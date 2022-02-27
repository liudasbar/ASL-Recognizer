import UIKit
import AVFoundation

extension HandPosesViews {
    class RootView: UIView {
        // MARK: - Views
        private lazy var handPosesCollectionView: UICollectionView = {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 4), height: 150)
            
            let collectionView: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            collectionView.register(
                HandPoseCollectionViewCell.self,
                forCellWithReuseIdentifier: cellReuseIdentifier
            )
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsVerticalScrollIndicator = true
            collectionView.backgroundColor = activeTheme.colors.text
            collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
            return collectionView
        }()
        
        // MARK: - Variables
        private let cellReuseIdentifier: String = "handPoseCell"
        private let handPosesData: [(title: String, image: UIImage)] = HandPosesData.data
        
        // MARK: - Life Cycle
        init() {
            super.init(frame: .zero)
            setupViews()
            setupHandPosesCollectionView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Setup
        private func setupViews() {
            backgroundColor = .clear
        }
        
        private func setupHandPosesCollectionView() {
            addSubview(handPosesCollectionView)
            handPosesCollectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                handPosesCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                handPosesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
                handPosesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
                handPosesCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}

extension HandPosesViews.RootView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        handPosesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as! HandPoseCollectionViewCell
        cell.handPoseImageView.image = handPosesData[indexPath.row].image
        cell.titleLabel.text = handPosesData[indexPath.row].title.uppercased()
        return cell
    }
}

//
//  FavoriteContainerTVC.swift
//  BatTransferList
//
//  Created by Siamak on 5/13/23.
//

import UIKit

// MARK: - FavoriteContainerTVC

class FavoriteContainerTVC: UITableViewCell {
    static let identifier = "FavoriteContainerTVC"

    var flow: UICollectionViewFlowLayout!
    var favorites: [TransferListDomainModel]?
    var selectedItemHandler: ((TransferListDomainModel) -> Void)?

    @IBOutlet var favoriteCollectionView: UICollectionView! {
        didSet {
            favoriteCollectionView.delegate = self
            favoriteCollectionView.dataSource = self
            favoriteCollectionView.register(UINib(nibName: FavoritesCVC.identifier, bundle: nil), forCellWithReuseIdentifier: FavoritesCVC.identifier)
            self.flow = UICollectionViewFlowLayout()
            flow.scrollDirection = .horizontal
            flow.minimumLineSpacing = 1
            flow.minimumInteritemSpacing = 1
            favoriteCollectionView.collectionViewLayout = flow
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(models: [TransferListDomainModel]) {
        self.favorites = models
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension FavoriteContainerTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCVC.identifier, for: indexPath) as? FavoritesCVC else {
            return .init()
        }
        guard let model = favorites?[indexPath.row] else {
            return .init()
        }
        cell.configureCell(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = favorites?[indexPath.row] else {
            return
        }
        selectedItemHandler?(model)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = favorites?[indexPath.row]
        let textSize: CGSize = model?.transferModel.person?.fullName?.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]) ?? .zero
        return CGSize(width: textSize.width, height: collectionView.frame.height)
    }
}

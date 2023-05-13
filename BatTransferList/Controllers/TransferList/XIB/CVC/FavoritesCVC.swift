//
//  FavoritesCVC.swift
//  BatTransferList
//
//  Created by Siamak on 5/13/23.
//

import UIKit

class FavoritesCVC: UICollectionViewCell {
    static let identifier = "FavoritesCVC"

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: TransferListDomainModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.transferModel.person?.fullName
            guard let avatar = model.transferModel.person?.avatar, let avatarURL = URL(string: avatar) else {
                return
            }

            DispatchQueue.global(qos: .background).async {
                guard let data = try? Data(contentsOf: avatarURL) else {
                    return
                }
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
        }
    }
}

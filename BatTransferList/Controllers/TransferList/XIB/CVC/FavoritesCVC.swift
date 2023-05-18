//
//  FavoritesCVC.swift
//  BatTransferList
//
//  Created by Siamak on 5/13/23.
//

import UIKit
import Nuke

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
            let option = ImageLoadingOptions(placeholder: UIImage(named: "batman-6-512"),transition: .fadeIn(duration: 0.3))
            Nuke.loadImage(with: avatarURL,options: option,into: self.profileImageView)
        }
    }
}

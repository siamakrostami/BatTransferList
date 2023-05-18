//
//  TransferListTVC.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit
import Nuke

class TransferListTVC: UITableViewCell {
    static let identifier = "TransferListTVC"

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var favoriteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        self.profileImageView.image = UIImage(named: "batman-6-512")
    }
    
    func configureCell(model: TransferListDomainModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.transferModel.person?.fullName
            self.subTitleLabel.text = model.transferModel.card?.cardNumber
            self.favoriteImageView.isHidden = !model.isFavorited
            guard let avatar = model.transferModel.person?.avatar , let avatarURL = URL(string: avatar) else {
                return
            }
            let option = ImageLoadingOptions(placeholder: UIImage(named: "batman-6-512"),transition: .fadeIn(duration: 0.3))
            Nuke.loadImage(with: avatarURL,options: option,into: self.profileImageView)
        }
    }
}

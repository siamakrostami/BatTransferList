//
//  PersonalTVC.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit
import Nuke

class PersonalTVC: UITableViewCell {
    static let identifier = "PersonalTVC"

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: TransferListDomainModel) {
        DispatchQueue.main.async {
            self.emailLabel.text = model.transferModel.person?.email
            guard let avatar = model.transferModel.person?.avatar, let avatarURL = URL(string: avatar) else {
                return
            }
            let option = ImageLoadingOptions(placeholder: UIImage(named: "batman-6-512"),transition: .fadeIn(duration: 0.3))
            Nuke.loadImage(with: avatarURL,options: option,into: self.profileImageView)
        }
    }
}

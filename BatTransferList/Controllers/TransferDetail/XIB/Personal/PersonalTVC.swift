//
//  PersonalTVC.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit

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
    
    func configureCell(model: TransferListModel) {
        DispatchQueue.main.async {
            self.emailLabel.text = model.person?.email
            guard let avatar = model.person?.avatar, let avatarURL = URL(string: avatar) else {
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

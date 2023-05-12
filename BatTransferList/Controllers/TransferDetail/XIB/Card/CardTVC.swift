//
//  CardTVC.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit

class CardTVC: UITableViewCell {
    static let identifier = "CardTVC"

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!

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
            self.typeLabel.text = model.card?.cardType
            self.numberLabel.text = model.card?.cardNumber
        }
    }
}

//
//  NoteTVC.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit

class NoteTVC: UITableViewCell {
    static let identifier = "NoteTVC"

    @IBOutlet var noteLabel: UILabel!

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
            self.noteLabel.text = model.transferModel.note
        }
    }
}

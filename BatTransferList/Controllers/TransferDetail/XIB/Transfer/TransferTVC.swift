//
//  TransferTVC.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit

class TransferTVC: UITableViewCell {
    
    static let identifier = "TransferTVC"

    @IBOutlet var lastTransferLabel: UILabel!
    @IBOutlet var numberOfTransferLabel: UILabel!
    @IBOutlet var totalTransferLabel: UILabel!

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
            self.lastTransferLabel.text = model.transferModel.lastTransfer
            self.numberOfTransferLabel.text = "\(model.transferModel.moreInfo?.numberOfTransfers ?? 0)"
            self.totalTransferLabel.text = "\(model.transferModel.moreInfo?.totalTransfer ?? 0)"
        }
    }
}

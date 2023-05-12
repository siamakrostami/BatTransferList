//
//  TransferListDomainModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

class TransferListDomainModel: Codable {
    var transferModel : TransferListModel
    var isFavorited: Bool
    init(transferModel: TransferListModel, isFavorited: Bool) {
        self.transferModel = transferModel
        self.isFavorited = isFavorited
    }
}

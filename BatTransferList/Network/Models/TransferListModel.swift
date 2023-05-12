//
//  TransferListModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

// MARK: - TransferListModel
struct TransferListModel: Codable {
    var person: PersonModel?
    var card: CardModel?
    var lastTransfer: String?
    var note: String?
    var moreInfo: MoreInfoModel?

    enum CodingKeys: String, CodingKey {
        case person, card
        case lastTransfer = "last_transfer"
        case note
        case moreInfo = "more_info"
    }
}

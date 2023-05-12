//
//  MoreInfoModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

// MARK: - MoreInfo
struct MoreInfoModel: Codable {
    var numberOfTransfers, totalTransfer: Int?

    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }
}

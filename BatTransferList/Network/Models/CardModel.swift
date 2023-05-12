//
//  CardModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

// MARK: - Card
struct CardModel: Codable {
    var cardNumber, cardType: String?

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }
}

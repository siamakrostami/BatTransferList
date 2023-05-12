//
//  PersonModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

// MARK: - Person
struct PersonModel: Codable {
    var fullName: String?
    var email: String?
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email, avatar
    }
}

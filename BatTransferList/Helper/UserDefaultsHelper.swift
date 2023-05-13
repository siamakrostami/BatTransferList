//
//  UserDefaultsHelper.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

// MARK: - UserDefaultsHelper

class UserDefaultsHelper {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared = UserDefaultsHelper()
}

extension UserDefaultsHelper {
    // MARK: - Insert model to userDefaults

    func insertModel(model: TransferListDomainModel) {
        if var dataArray = UserDefaults.standard.object(forKey: "favorites") as? Data {
            guard var decoded = try? JSONDecoder().decode([TransferListDomainModel].self, from: dataArray) else {
                return
            }
            decoded.append(model)
            guard let encoded = try? JSONEncoder().encode(decoded) else {
                return
            }
            UserDefaults.standard.set(encoded, forKey: "favorites")

        } else {
            var dataArray = [TransferListDomainModel]()
            dataArray.append(model)
            guard let encoded = try? JSONEncoder().encode(dataArray) else {
                return
            }
            UserDefaults.standard.setValue(encoded, forKey: "favorites")
        }
        UserDefaults.standard.synchronize()
    }

    // MARK: - Get all card numbers from userDefaults

    func getStoredCardNumbers() -> [String]? {
        guard let dataArray = UserDefaults.standard.object(forKey: "favorites") as? Data else {
            return nil
        }
        guard var decoded = try? JSONDecoder().decode([TransferListDomainModel].self, from: dataArray) else {
            return nil
        }
        return decoded.map { $0.transferModel.card?.cardNumber ?? "" }
    }

    // MARK: - Remove model from userDefaults

    func removeModel(model: TransferListDomainModel) {
        guard let dataArray = UserDefaults.standard.object(forKey: "favorites") as? Data else {
            return
        }
        guard var decoded = try? JSONDecoder().decode([TransferListDomainModel].self, from: dataArray) else {
            return
        }
        guard let index = decoded.firstIndex(where: { $0.transferModel.card?.cardNumber ?? "" == model.transferModel.card?.cardNumber ?? "" }) else {
            return
        }
        decoded.remove(at: index)
        guard let encoded = try? JSONEncoder().encode(decoded) else {
            return
        }
        UserDefaults.standard.set(encoded, forKey: "favorites")
        UserDefaults.standard.synchronize()
    }

    // MARK: - Get stored models

    func getFavoriteModels() -> [TransferListDomainModel]? {
        guard let dataArray = UserDefaults.standard.object(forKey: "favorites") as? Data else {
            return nil
        }
        guard var decoded = try? JSONDecoder().decode([TransferListDomainModel].self, from: dataArray) else {
            return nil
        }

        return decoded
    }
}

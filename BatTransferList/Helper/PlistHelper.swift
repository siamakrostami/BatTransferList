//
//  PlistHelper.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

class PlistHelper {
    class var baseURL: String {
        return Bundle.main.infoDictionary?["baseURL"] as? String ?? ""
    }

    class var path: String {
        return Bundle.main.infoDictionary?["path"] as? String ?? ""
    }
}

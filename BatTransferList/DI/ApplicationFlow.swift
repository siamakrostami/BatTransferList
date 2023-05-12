//
//  ApplicationFlow.swift
//  Architecture
//
//  Created by Siamak on 4/17/23.
//

import Foundation

// MARK: - ApplicationFlow

enum ApplicationFlow {
    case TransferList
    case TransferDetail
}

// MARK: Equatable

extension ApplicationFlow: Equatable {
    static func == (lhs: ApplicationFlow, rhs: ApplicationFlow) -> Bool {
        switch (lhs, rhs) {
        case (.TransferList, .TransferList),
            (.TransferDetail, .TransferDetail):
            return true
        default:
            return false
        }
    }
}

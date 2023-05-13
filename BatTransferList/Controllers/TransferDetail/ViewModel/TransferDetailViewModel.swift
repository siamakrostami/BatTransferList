//
//  TransferDetailViewModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation
import Combine

enum DetailSection: String, CaseIterable {
    case Personal = "Personal"
    case Card = "Card"
    case Transfer = "Transfer"
    case Note = "Note"
}

class TransferDetailViewModel : BaseViewModel<DependencyContainer> {
    
    init(dependency: DependencyContainer, model: TransferListDomainModel) {
        self.container = dependency
        self.currentModel = model
        super.init(dependency: self.container)
    }
    
    required init(dependency: Dependency) {
        fatalError("init(dependency:) has not been implemented")
    }

    // MARK: Internal

    var container: DependencyContainer
    var currentModel : TransferListDomainModel
    var shouldRealodTable = CurrentValueSubject<Bool?,Never>(nil)
    var sections = DetailSection.allCases

}

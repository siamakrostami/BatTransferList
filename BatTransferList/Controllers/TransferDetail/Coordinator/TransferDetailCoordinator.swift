//
//  TransferDetailCoordinator.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation

extension BaseCoordinator {
    func openTransferDetail(dependency: DependencyContainer, model: TransferListModel) {
        let controller = TransferDetailViewController.instantiateViewController()
        controller.viewModel = .init(dependency: dependency, model: model)
        controller.coordinator = self
        self.handleNavigation(style: .push(viewController: controller, animated: true))
    }
}

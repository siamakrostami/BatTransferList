//
//  TransferListCoordinator.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation
import UIKit

extension BaseCoordinator {
    
    func setTransferListAsRoot(dependency: DependencyContainer) -> UIViewController {
        let controller = TransferListViewController.instantiateViewController()
        controller.viewModel = .init(dependency: dependency)
        controller.coordinator = self
        return controller
    }
    
    func openTransferList(dependency: DependencyContainer) {
        let controller = TransferListViewController.instantiateViewController()
        controller.viewModel = .init(dependency: dependency)
        controller.coordinator = self
        self.handleNavigation(style: .push(viewController: controller, animated: true))
    }

    
}

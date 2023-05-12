//
//  TransferListCoordinator.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation
import UIKit

extension BaseCoordinator {
    
    //MARK: - Set transfer list as root controller
    func setTransferListAsRoot(dependency: DependencyContainer) -> UIViewController {
        let controller = TransferListViewController.instantiateViewController()
        controller.viewModel = .init(dependency: dependency)
        controller.coordinator = self
        return controller
    }
    
    //MARK: - Navigate from another controller to the transfer list controller
    func openTransferList(dependency: DependencyContainer) {
        let controller = TransferListViewController.instantiateViewController()
        controller.viewModel = .init(dependency: dependency)
        controller.coordinator = self
        self.handleNavigation(style: .push(viewController: controller, animated: true))
    }

    
}

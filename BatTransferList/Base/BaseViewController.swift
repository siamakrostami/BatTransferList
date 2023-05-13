//
//  BaseViewController.swift
//  Architecture
//
//  Created by Siamak on 4/17/23.
//

import Foundation
import UIKit

// MARK: - BaseViewController

class BaseViewController: UIViewController, StoryboardInstantiable {
    weak var coordinator: BaseCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.hideKeyboardWhenTappedAround()
    }
    
    func bind() {}
}

extension BaseViewController {
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .destructive)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }

}

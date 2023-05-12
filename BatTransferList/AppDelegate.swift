//
//  AppDelegate.swift
//  Architecture
//
//  Created by Siamak on 4/17/23.
//

import Combine
import UIKit

// MARK: - AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Internal

    var coordinator: BaseCoordinator?
    var environment = AppEnvironment.setup()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        environment.container.applicationDataContainer.applicationFlow.send(.TransferList)
        setupWindow()
        bindFlowChange()
        return true
    }

    // MARK: Private

    private var cancellableSet = Set<AnyCancellable>()
}

extension AppDelegate {
    private func setupWindow() {
        coordinator = .init()
        window = UIWindow(frame: UIScreen.main.bounds)
    }

    private func bindFlowChange() {
        environment.container.applicationDataContainer.applicationFlow
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] flow in
                guard let `self` = self, let flow = flow else {
                    return
                }
                self.window?.rootViewController = self.coordinator?.setApplicationFlow(flow: flow, dependency: self.environment.container)
                self.window?.makeKeyAndVisible()
            }
            .store(in: &cancellableSet)
    }
}

//
//  AppCoordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 20.07.21.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: - Coordinator
extension AppCoordinator: Coordinator {
    func start() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let mainMenu = MainMenuCoordinator(navigationController: navigationController)
        coordinate(to: mainMenu)
    }
}

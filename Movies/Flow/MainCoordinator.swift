//
//  MainCoordinator.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    let window: UIWindow?
    var presenter: UITabBarController
    var childCoordinators: [BaseCoordinator]
    var onFinish: (() -> Void)?
    
    init(window: UIWindow?) {
        self.window = window
        presenter = MainTabBarController.instantiate()
        childCoordinators = []
    }
    
    func start() {
        childCoordinators = [DiscoverCoordinator(), MyListsCoordinator(), SearchCoordinator()]
        childCoordinators.forEach { $0.start() }
        presenter.viewControllers = childCoordinators.map { $0.presenter }
        
        window?.rootViewController = presenter
        window?.makeKeyAndVisible()
    }

}

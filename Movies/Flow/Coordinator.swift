//
//  Coordinator.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var onFinish: (() -> Void)? { get set }
    func start()
}

protocol BaseCoordinator: Coordinator {
    var presenter: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    func addDependency(_ coordinator: Coordinator)
    func removeDependency(_ coordinator: Coordinator)
}

extension BaseCoordinator {
    
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators += [coordinator]
    }
    
    func removeDependency(_ coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator } )
    }
    
}

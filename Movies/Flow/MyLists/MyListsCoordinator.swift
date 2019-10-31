//
//  MyListsCoordinator.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class MyListsCoordinator: BaseCoordinator {
    
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var onFinish: (() -> Void)?
    
    init() {
        presenter = UINavigationController()
        presenter.tabBarItem = UITabBarItem(
            title: "My Lists",
            image: UIImage(systemName: "text.badge.star"),
            tag: 1
        )
        childCoordinators = []
    }
    
    func start() {
        let myListsVC = makeMyListsViewController()
        presenter.pushViewController(myListsVC, animated: true)
    }
    
    func makeMyListsViewController() -> UIViewController {
        let myListsVC = MyListsViewController.instantiate()
        myListsVC.viewModel = MyListsViewModel()
        myListsVC.onMovieDisclosure = { movie in
            self.showMovieDetailScreen(movie: movie)
        }
        return myListsVC
    }
    
    private func showMovieDetailScreen(movie: Movie) {
        let movieDetailVC = makeMovieDetailViewController(movie: movie)
        presenter.pushViewController(movieDetailVC, animated: true)
    }
    
    private func makeMovieDetailViewController(movie: Movie) -> MovieDetailViewController {
        let movieDetailVC = MovieDetailViewController.instantiate()
        movieDetailVC.viewModel = MovieDetailViewModel(model: movie)
        return movieDetailVC
    }
    
}

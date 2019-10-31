//
//  DiscoverCoordinator.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class DiscoverCoordinator: BaseCoordinator {
    
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var onFinish: (() -> Void)?
    
    init() {
        presenter = UINavigationController()
        presenter.tabBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "film"),
            tag: 0
        )
        childCoordinators = []
    }
    
    func start() {
        let discoverVC = makeDiscoverViewController()
        presenter.pushViewController(discoverVC, animated: true)
    }
    
    private func makeDiscoverViewController() -> UIViewController {
        let discoverVC = DiscoverViewController.instantiate()
        discoverVC.onMovieTapped = { movie in
            self.showMovieDetailScreen(movie: movie)
        }
        discoverVC.onListViewTapped = { category in
            self.showMoviesListScreen(of: category)
        }
        return discoverVC
    }
    
    private func showMovieDetailScreen(movie: Movie) {
        let movieDetailVC = makeMovieDetailViewController(movie: movie)
        presenter.pushViewController(movieDetailVC, animated: true)
    }
    
    private func showMoviesListScreen(of category: Movie.Category) {
        let moviesListVC = makeMoviesListViewController(category: category)
        presenter.pushViewController(moviesListVC, animated: true)
    }
    
    private func makeMoviesListViewController(category: Movie.Category) -> MoviesListViewController {
        let moviesListVC = MoviesListViewController.instantiate()
        let viewModel = CategoryMoviesListViewModel(category: category)
        moviesListVC.viewModel = viewModel
        moviesListVC.title = viewModel.category.displayableText
        moviesListVC.onMovieTapped = { movie in
            self.showMovieDetailScreen(movie: movie)
        }
        return moviesListVC
    }
    
    private func makeMovieDetailViewController(movie: Movie) -> MovieDetailViewController {
        let movieDetailVC = MovieDetailViewController.instantiate()
        movieDetailVC.viewModel = MovieDetailViewModel(model: movie)
        return movieDetailVC
    }
    
}

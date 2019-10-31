//
//  SearchCoordinator.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class SearchCoordinator: BaseCoordinator {
    
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var onFinish: (() -> Void)?
    
    init() {
        presenter = UINavigationController()
        presenter.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 2
        )
        childCoordinators = []
    }
    
    func start() {
        let searchVC = makeSearchViewController()
        presenter.pushViewController(searchVC, animated: true)
    }
    
    func makeSearchViewController() -> UIViewController {
        let searchVC = SearchViewController.instantiate()
        let searchViewModel = SearchMoviesListViewModel()
        searchVC.moviesListVC = makeMoviesListViewController(with: searchViewModel)
        searchVC.viewModel = searchViewModel
        return searchVC
    }
    
    private func makeMoviesListViewController(with viewModel: MoviesListViewModelType) -> MoviesListViewController {
        let moviesListVC = MoviesListViewController.instantiate()
        moviesListVC.viewModel = viewModel
        moviesListVC.onMovieTapped = { movie in
            self.showMovieDetailScreen(movie: movie)
        }
        return moviesListVC
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

//
//  CategoryViewModel.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
import RxCocoa

typealias CategoryMoviesListViewModelType = CategoryViewModelType & MoviesListViewModelType

protocol CategoryViewModelType {
    var category: Movie.Category { get }
}

final class CategoryMoviesListViewModel: CategoryMoviesListViewModelType {
    
    // MARK: Properties
    var moviesListViewModel: MoviesListViewModel
    var movieSource: DataSource
    var category: Movie.Category
    
    // MARK: Initializers
    init(moviesListViewModel: MoviesListViewModel = MoviesListViewModel(),
         movieSource: DataSource = CacheableDataSource(),
         category: Movie.Category
    ) {
        self.moviesListViewModel = moviesListViewModel
        self.movieSource = movieSource
        self.category = category
        moviesListViewModel.fetchDelegate = self
    }
    
}

extension CategoryMoviesListViewModel {
    
    var nextPageTrigger: PublishSubject<Void> {
        return moviesListViewModel.nextPageTrigger
    }
    
    var newSearchTrigger: PublishSubject<Void> {
        return moviesListViewModel.newSearchTrigger
    }
    
    var movies: Driver<[Movie]> {
        return moviesListViewModel.movies
    }
    
}

extension CategoryMoviesListViewModel: MoviesListFetchDelegate {
    
    func getMovies(page: Int) -> Observable<[Movie]> {
        return movieSource.getMovies(for: category, page: page)
            .asObservable()
            .map { $0.results }
    }
    
}

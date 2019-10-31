//
//  MyListsMoviesListViewModel.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MyListsViewModelType {
    
    // MARK: Inputs
    var listSwitchTrigger: PublishSubject<Movie.List> { get }
    var movieUnlistTrigger: PublishSubject<(movie: Movie, list: Movie.List)> { get }
    
    // MARK: Outputs
    var movies: Driver<[Movie]> { get }
}

final class MyListsViewModel: MyListsViewModelType {
    
    // MARK: Properties
    var movieSource: DataSource
    var listSwitchTrigger = PublishSubject<Movie.List>()
    var movieUnlistTrigger = PublishSubject<(movie: Movie, list: Movie.List)>()
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    private var _movies = BehaviorRelay<[Movie]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: Initializers
    init(movieSource: DataSource = CacheableDataSource()) {
        self.movieSource = movieSource
        initBindings()
    }
    
    // MARK: Private methods
    private func initBindings() {
        let listUpdate = listSwitchTrigger
            .do(onNext: { list in self._movies.accept([])})
            .flatMap { list in self.movieSource.getMovies(of: list) }
            .map { movie -> [Movie] in
                var result = self._movies.value
                result.append(movie)
                return result
            }
        
        listUpdate
            .bind(to: _movies)
            .disposed(by: disposeBag)
        
        movieUnlistTrigger
            .subscribe(onNext: { [unowned self] unlist in
                let (movie, list) = unlist
                CoreDataManager.shared.updateListStatusOfMovie(with: movie.id, list: list, status: false)
                self.listSwitchTrigger.onNext(list)
            })
            .disposed(by: disposeBag)
    }
    
}

//
//  LocalDataSource.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

struct LocalDataSource: DataSource {
    
    func getMovie(by id: Int, completion: @escaping (Movie) -> Void) {
        let movieEntity = CoreDataManager.shared.getMovieEntity(by: id)
        guard let movie = movieEntity?.toMovie() else { return }
        completion(movie)
    }
    
    func getGenres(completion: @escaping ([Genre]) -> Void) {
        let genres = CoreDataManager.shared.getAllGenreEntities().compactMap { $0.toGenre() }
        completion(genres)
    }
    
    func getMovies(for category: Movie.Category, page: Int) -> Single<PagedMoviesResponse> {
        let movies = CoreDataManager.shared.getMovieEntities(for: category, page: page).compactMap { $0.toMovie() }
        let categoryMaxPageNumber = CoreDataManager.shared.getMaxPageNumber(for: category)
        let pagedResponse = PagedMoviesResponse(results: movies, page: page, totalPages: categoryMaxPageNumber ?? page)
        return .just(pagedResponse)
    }
    
    func getMovies(of list: Movie.List) -> Observable<Movie> {
        let movies = CoreDataManager.shared.getMovieEntities(of: list).compactMap { $0.toMovie() }
        return Observable.create { observer in
            movies.forEach { observer.onNext($0) }
            return Disposables.create()
        }
    }
    
    func searchMovies(by keyword: String, page: Int) -> Single<PagedMoviesResponse> {
        let movies = CoreDataManager.shared.searchMovies(by: keyword).compactMap { $0.toMovie() }
        let pagedResponse = PagedMoviesResponse(results: movies, page: page, totalPages: page)
        return .just(pagedResponse)
    }
    
    func saveMovies(from pagedResponse: PagedMoviesResponse, forCategory category: Movie.Category) {
        CoreDataManager.shared.saveMoviesIfNeeded(pagedResponse.results)
        
        let movieIds = pagedResponse.results.map { $0.id }
        CoreDataManager.shared.saveMovieIds(movieIds, category: category, page: pagedResponse.page)
    }
    
    func saveMovie(_ movie: Movie) {
        CoreDataManager.shared.saveMovie(movie)
    }
    
}

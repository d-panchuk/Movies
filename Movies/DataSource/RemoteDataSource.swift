//
//  RemoteDataSource.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

struct RemoteDataSource: DataSource, NetworkManagerInjectable {
    
    func getMovie(by id: Int, completion: @escaping (Movie) -> Void) {
        networkManager.getMovie(by: id) { completion($0) }
    }
    
    func getGenres(completion: @escaping ([Genre]) -> Void) {
        networkManager.getGenres { completion($0.genres) }
    }
    
    func getMovies(for category: Movie.Category, page: Int) -> Single<PagedMoviesResponse> {
        return networkManager.getMovies(for: category, page: page)
    }
    
    func getMovies(of list: Movie.List) -> Observable<Movie> {
        return networkManager.getMovies(of: list)
    }
    
    func searchMovies(by keyword: String, page: Int) -> Single<PagedMoviesResponse> {
        return networkManager.searchMovies(by: keyword, page: page)
    }
    
}

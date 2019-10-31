//
//  CacheableDataSource.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

struct CacheableDataSource: DataSource {
    
    var remoteSource: RemoteDataSource
    var localSource: LocalDataSource
    
    init(remoteSource: RemoteDataSource = RemoteDataSource(), localSource: LocalDataSource = LocalDataSource()) {
        self.remoteSource = remoteSource
        self.localSource = localSource
    }
    
    func getMovie(by id: Int, completion: @escaping (Movie) -> Void) {
        if UIDevice.isConnectedToNetwork {
            remoteSource.getMovie(by: id) { movie in
                self.localSource.saveMovie(movie)
                completion(movie)
            }
        } else {
            localSource.getMovie(by: id) { movie in
                completion(movie)
            }
        }
    }
    
    func getGenres(completion: @escaping ([Genre]) -> Void) {
        localSource.getGenres { genresResponse in
            completion(genresResponse)
        }
    }
    
    func getMovies(for category: Movie.Category, page: Int) -> Single<PagedMoviesResponse> {
        let pagedMovies: Single<PagedMoviesResponse>
        if UIDevice.isConnectedToNetwork {
            pagedMovies = remoteSource.getMovies(for: category, page: page)
                .do(onSuccess: { pagedResponse in
                    self.localSource.saveMovies(from: pagedResponse, forCategory: category)
                })
        } else {
            pagedMovies = localSource.getMovies(for: category, page: page)
        }
        return pagedMovies
    }
    
    func getMovies(of list: Movie.List) -> Observable<Movie> {
        return UIDevice.isConnectedToNetwork ?
            remoteSource.getMovies(of: list) :
            localSource.getMovies(of: list)
    }
    
    func searchMovies(by keyword: String, page: Int) -> Single<PagedMoviesResponse> {
        let pagedMovies: Single<PagedMoviesResponse>
        if UIDevice.isConnectedToNetwork {
            pagedMovies = remoteSource.searchMovies(by: keyword, page: page)
        } else {
            pagedMovies = localSource.searchMovies(by: keyword, page: page)
        }
        return pagedMovies
    }
    
}

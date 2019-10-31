//
//  DataSource.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

protocol DataSource {
    func getMovie(by id: Int, completion: @escaping (Movie) -> Void)
    func getGenres(completion: @escaping ([Genre]) -> Void)
    func getMovies(for category: Movie.Category, page: Int) -> Single<PagedMoviesResponse>
    func getMovies(of list: Movie.List) -> Observable<Movie>
    func searchMovies(by keyword: String, page: Int) -> Single<PagedMoviesResponse>
}

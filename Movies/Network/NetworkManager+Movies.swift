//
//  MoviesNetworkManager.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation
import RxSwift

extension NetworkManager {
    
    func getMovie(by id: Int, completion: @escaping (Movie) -> Void) {
        let request = GetMovieRequest(id: id)
        _ = execute(
            request: request,
            onSuccess: { completion($0) },
            onError: { error in print("Error during fetching movie: \(error)") }
        )
    }
    
    func getMovies(for category: Movie.Category, page: Int) -> Single<PagedMoviesResponse> {
        let request: RequestType
        
        switch category {
        case .popular:
            request = GetPopularMoviesRequest(page: page)
        case .topRated:
            request = GetTopRatedMoviesRequest(page: page)
        case .upcoming:
            request = GetUpcomingMoviesRequest(page: page)
        case .nowPlaying:
            request = GetNowPlayingMoviesRequest(page: page)
        }
        
        return execute(request: request)
    }
    
    func getMovies(of list: Movie.List) -> Observable<Movie> {
        let movieIds = CoreDataManager.shared.getMovieIds(of: list)
        return Observable<Movie>.create { observer in
            let group = DispatchGroup()
            
            for id in movieIds {
                group.enter()
                self.getMovie(by: id) { movie in
                    observer.on(.next(movie))
                    group.leave()
                }
            }
            
            group.notify(queue: .global(), execute: { observer.onCompleted() })
            
            return Disposables.create()
        }
    }
    
    func searchMovies(by keyword: String, page: Int) -> Single<PagedMoviesResponse> {
        let request = SearchMoviesRequest(keyword: keyword, page: page)
        return execute(request: request)
    }
    
    func getGenres(completion: @escaping (GenresResponse) -> Void) {
        let request = GetGenresRequest()
        _ = execute(
            request: request,
            onSuccess: { completion($0) },
            onError: { error in print("Error during fetching genres: \(error)") }
        )
    }
    
}

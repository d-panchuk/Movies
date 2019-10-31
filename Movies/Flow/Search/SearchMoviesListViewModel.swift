//
//  SearchMoviesListViewModel.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
import RxCocoa

typealias SearchMoviesListViewModelType = SearchViewModelType & MoviesListViewModelType

protocol SearchViewModelType {
    
    // MARK: Inputs
    var keywordUpdateTrigger: PublishSubject<String> { get }
    var latestSearchesClearTrigger: PublishSubject<Void> { get }
    
    // MARK: Output
    var latestSearches: Driver<[String]> { get }
}

final class SearchMoviesListViewModel: SearchMoviesListViewModelType {
    
    // MARK: Properties
    var moviesListViewModel: MoviesListViewModel
    var keywordUpdateTrigger = PublishSubject<String>()
    var latestSearchesClearTrigger = PublishSubject<Void>()
    var latestSearches: Driver<[String]> {
        return _latestSearches.asDriver()
    }
    var movieSource: DataSource

    private var currentKeyword = ""
    private var totalPages: Int?
    private var _latestSearches = BehaviorRelay<[String]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: Initializers
    init(moviesListViewModel: MoviesListViewModel = MoviesListViewModel(),
        movieSource: DataSource = CacheableDataSource()
    ) {
        self.moviesListViewModel = moviesListViewModel
        self.movieSource = movieSource
        moviesListViewModel.fetchDelegate = self
        initBindings()
    }
    
    private func initBindings() {
        keywordUpdateTrigger
            .subscribe(onNext: { keyword in
                self.currentKeyword = keyword
                self.totalPages = nil
                self.moviesListViewModel.newSearchTrigger.onNext(())
                self.saveSearchKeyword(keyword)
            })
            .disposed(by: disposeBag)
        
        latestSearchesClearTrigger
            .subscribe(onNext: { self.clearLatestsSearches() })
            .disposed(by: disposeBag)
        
        let keywordsSaved = UserDefaults.standard.rx
            .observe([String].self, Constants.Defaults.lastSearchesKey)
        
        keywordsSaved
            .subscribe(onNext: { keywords in self._latestSearches.accept(keywords ?? []) })
            .disposed(by: disposeBag)
    }
    
    private func saveSearchKeyword(_ keyword: String) {
        var keywords = UserDefaults.standard.stringArray(forKey: Constants.Defaults.lastSearchesKey) ?? []
        guard !keyword.isEmpty, !keywords.contains(keyword) else { return }
        keywords.insert(keyword, at: 0)
        UserDefaults.standard.set(keywords, forKey: Constants.Defaults.lastSearchesKey)
    }
    
    private func clearLatestsSearches() {
        UserDefaults.standard.set([], forKey: Constants.Defaults.lastSearchesKey)
    }
    
}

extension SearchMoviesListViewModel {
    
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

extension SearchMoviesListViewModel: MoviesListFetchDelegate {
    
    func getMovies(page: Int) -> Observable<[Movie]> {
        guard !currentKeyword.isEmpty else { return Observable.just([]) }
        if let totalPages = totalPages, page > totalPages { return Observable.just([]) }

        return movieSource.searchMovies(by: currentKeyword, page: page)
            .asObservable()
            .do(onNext: { self.totalPages = $0.totalPages })
            .map { $0.results }
    }
    
}

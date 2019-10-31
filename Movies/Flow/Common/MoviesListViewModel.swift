//
//  MoviesListViewModel.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MoviesListViewModelType {
    
    // MARK: Inputs
    var nextPageTrigger: PublishSubject<Void> { get }
    var newSearchTrigger: PublishSubject<Void> { get }
    
    // MARK: Outputs
    var movies: Driver<[Movie]> { get }
}

protocol MoviesListFetchDelegate: class {
    func getMovies(page: Int) -> Observable<[Movie]>
}

class MoviesListViewModel: MoviesListViewModelType {
    
    // MARK: Properties
    var nextPageTrigger = PublishSubject<Void>()
    var newSearchTrigger = PublishSubject<Void>()
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    weak var fetchDelegate: MoviesListFetchDelegate?
    
    private var _movies = BehaviorRelay<[Movie]>(value: [])
    private var nextPage = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    // MARK: Initializers
    init() {
        initBindings()
    }
    
    // MARK: Private methods
    private func initBindings() {
        let nextPageUpdate = nextPage
            .flatMap { [unowned self] nextPage in (self.fetchDelegate?.getMovies(page: nextPage) ?? Observable.just([])) }
            .map { [weak self] in (self?._movies.value ?? []) + $0 }
        
        nextPageUpdate
            .asDriver(onErrorJustReturn: [])
            .drive(_movies)
            .disposed(by: disposeBag)
        
        nextPageTrigger
            .subscribe(onNext: { [unowned self] in
                let previousPage = self.nextPage.value
                self.nextPage.accept(previousPage + 1)
            })
            .disposed(by: disposeBag)
        
        newSearchTrigger
            .subscribe(onNext: { [unowned self] in
                self._movies.accept([])
                let firstPage = 1
                self.nextPage.accept(firstPage)
            })
            .disposed(by: disposeBag)
    }
    
}

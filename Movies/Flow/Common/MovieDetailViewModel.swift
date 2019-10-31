//
//  MovieDetailViewModel.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieDetailViewModelType {
    var model: Movie { get }
    var title: String { get }
    var backdropImagePath: String? { get }
    var combinedDescription: String { get }
    var countries: String { get }
    var genres: [String] { get }
    var rating: String { get }
    var votesCount: String { get }
    var overview: String { get }
    
    var watchStatusImage: UIImage { get }
    var favoriteStatusImage: UIImage { get }
    var watchLaterStatusImage: UIImage { get }
    
    // MARK: Inputs
    var watchStatusChange: PublishRelay<Void> { get }
    var favoriteStatusChange: PublishRelay<Void> { get }
    var watchLaterStatusChange: PublishRelay<Void> { get }
    
    // MARK: Outputs
    var modelDidChange: Driver<Void> { get }
}

final class MovieDetailViewModel: MovieDetailViewModelType, NetworkManagerInjectable {
        
    // MARK: Properties
    var model: Movie {
        didSet { _modelDidChange.accept(()) }
    }
    let dataSource: DataSource
    
    var watchStatusChange = PublishRelay<Void>()
    var favoriteStatusChange = PublishRelay<Void>()
    var watchLaterStatusChange = PublishRelay<Void>()
    var modelDidChange: Driver<Void> {
        return _modelDidChange.asDriver(onErrorJustReturn: ())
    }
    
    private let _modelDidChange = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private var isWatched: Bool {
        get {
            CoreDataManager.shared.listStatusOfMovie(with: model.id, list: .watched)
        }
        set {
            CoreDataManager.shared.updateListStatusOfMovie(
                with: model.id, list: Movie.List.watched, status: newValue)
        }
    }
    
    private var isFavorite: Bool
    {
        get {
            CoreDataManager.shared.listStatusOfMovie(with: model.id, list: .favorite)
        }
        set {
            CoreDataManager.shared.updateListStatusOfMovie(
                with: model.id, list: Movie.List.favorite, status: newValue)
        }
    }
    
    private var shouldWatchLater: Bool
    {
        get {
            CoreDataManager.shared.listStatusOfMovie(with: model.id, list: .watchLater)
        }
        set {
            CoreDataManager.shared.updateListStatusOfMovie(
                with: model.id, list: Movie.List.watchLater, status: newValue)
        }
    }

    var title: String {
        return model.title
    }
    
    var backdropImagePath: String? {
        return model.fullBackdropPath
    }
    
    var combinedDescription: String {
        let releaseDate = makeReleaseDateString(from: model.releaseDate)
        let duration = model.runtime.map { "\($0) mins" } 
        return [releaseDate, duration].compactMap { $0 }.joined(separator: Constants.Format.bulletSeparator)
    }
    
    var countries: String {
        guard let _countries = model.productionCountries, _countries.count > 0 else { return Constants.Format.dash }
        return _countries.map { $0.name }.joined(separator: Constants.Format.commaSeparator)
    }
    
    var genres: [String] {
        if let genresList = model.genres {
            return genresList.map { $0.name }
        } else if let genreIds = model.genreIds {
            return getGenreNames(using: genreIds)
        } else {
            return []
        }
    }
    
    var rating: String {
        let ratingString = model.voteAverage > 0 ? "\(model.voteAverage)" : Constants.Format.dash
        return "\(ratingString)"
    }
    
    var votesCount: String {
        return "\(model.voteCount) votes"
    }
    
    var overview: String {
        guard let _overview = model.overview, !_overview.isEmpty else { return Constants.Format.dash }
        return _overview
    }
    
    var watchStatusImage: UIImage {
        let icon = UIImage(systemName: Movie.List.watched.iconName)!
        let filledIcon = UIImage(systemName: Movie.List.watched.filledIconName)!
        return isWatched ? filledIcon : icon
    }
    
    var favoriteStatusImage: UIImage {
        let icon = UIImage(systemName: Movie.List.favorite.iconName)!
        let filledIcon = UIImage(systemName: Movie.List.favorite.filledIconName)!
        return isFavorite ? filledIcon : icon
    }
    
    var watchLaterStatusImage: UIImage {
        let icon = UIImage(systemName: Movie.List.watchLater.iconName)!
        let filledIcon = UIImage(systemName: Movie.List.watchLater.filledIconName)!
        return shouldWatchLater ? filledIcon : icon
    }
    
    // MARK: Initializers
    init(model: Movie, dataSource: DataSource = CacheableDataSource()) {
        self.model = model
        _modelDidChange.accept(())
        
        self.dataSource = dataSource
        initBindings()
        updateMovie()
    }
    
    // MARK: Private methods
    private func initBindings() {
        watchStatusChange
            .subscribe(onNext: { [unowned self] in
                self.isWatched.toggle()
                self._modelDidChange.accept(())
            })
            .disposed(by: disposeBag)
        
        favoriteStatusChange
            .subscribe(onNext: { [unowned self] in
                self.isFavorite.toggle()
                self._modelDidChange.accept(())
            })
            .disposed(by: disposeBag)
        
        watchLaterStatusChange
            .subscribe(onNext: { [unowned self] in
                self.shouldWatchLater.toggle()
                self._modelDidChange.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    private func updateMovie() {
        dataSource.getMovie(by: model.id) { [weak self] movie in
            self?.model = movie
        }
    }
    
    private func makeReleaseDateString(from stringDate: String) -> String? {
        guard let date = stringDate.toDate() else { return nil }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let monthInWord = DateFormatter().monthSymbols[month - 1]
        return "\(year), \(monthInWord) \(day)"
    }
    
    private func getGenreNames(using genreIds: [Int]) -> [String] {
        let genreEntities = CoreDataManager.shared.getAllGenreEntities()
        let genreNames = genreIds.compactMap { id in genreEntities.first(where: { $0.id == id })?.name }
        return genreNames
    }
    
}

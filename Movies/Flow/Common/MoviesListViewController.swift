//
//  MoviesListViewController.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MoviesListViewController: UIViewController, Storyboarded {
    
    // MARK: Outlets
    @IBOutlet private weak var moviesTableView: UITableView!
    
    // MARK: Properties
    var viewModel: MoviesListViewModelType!
    var onMovieTapped: ((Movie) -> (Void))?
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.register(
            UINib(nibName: "MovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier
        )
        
        initBindings()
    }
    
    // MARK: Private methods
    private func initBindings() {
        viewModel.movies
            .drive(
                moviesTableView.rx.items(
                    cellIdentifier: MovieTableViewCell.reuseIdentifier,
                    cellType: MovieTableViewCell.self)
            ) { (_, movie, cell) in
                cell.viewModel = MovieCellViewModel(model: movie)
            }
            .disposed(by: disposeBag)

        let moviesTableViewUpdate = moviesTableView.rx.contentOffset
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { [weak self] _ in self?.moviesTableView.isNearBottomEdge() ?? false }
            .flatMapLatest { _ in Observable.just(()) }

        moviesTableViewUpdate
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        let itemSelected = moviesTableView.rx.itemSelected
        let modelSelected = moviesTableView.rx.modelSelected(Movie.self)
        Observable
            .zip(itemSelected, modelSelected)
            .subscribe(onNext: { [unowned self] indexPath, movie in
                guard let cell = self.moviesTableView.cellForRow(at: indexPath) else { return }
                self.view.isUserInteractionEnabled = false

                UIView.animateTap(view: cell, completion: {
                    self.onMovieTapped?(movie)
                    self.view.isUserInteractionEnabled = true
                })
            })
            .disposed(by: disposeBag)
        
        moviesTableView.rx.willDisplayCell
            .subscribe(onNext: { UIView.animateAppearence(view: $0.cell, dx: -100) })
            .disposed(by: disposeBag)
    }
    
}

extension UIScrollView {
    
}

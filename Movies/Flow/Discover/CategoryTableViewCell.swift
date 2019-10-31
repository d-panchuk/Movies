//
//  CategoryTableViewCell.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var listViewButton: UIButton!
    @IBOutlet private weak var moviesCollectionView: UICollectionView!
    
    // MARK: Properties
    weak var discoverVC: DiscoverViewController!
    var viewModel: CategoryMoviesListViewModelType! {
        didSet { setup() }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moviesCollectionView.register(
            UINib(nibName: "MovieCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier
        )
    }
    
    // MARK: Private methods
    private func setup() {
        categoryNameLabel.text = viewModel.category.displayableText
        initBindings()
    }
    
    private func initBindings() {
        viewModel.movies
            .drive(
                moviesCollectionView.rx.items(
                    cellIdentifier: MovieCollectionViewCell.reuseIdentifier,
                    cellType: MovieCollectionViewCell.self)
            ) { (_, movie, cell) in
                cell.configure(from: MovieCellViewModel(model: movie))
            }
        .disposed(by: disposeBag)
        
        let categoryUpdate = moviesCollectionView.rx.contentOffset
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { _ in self.moviesCollectionView.isNearRightEdge() }
            .flatMapLatest { _ in Observable.just(()) }
        
        categoryUpdate
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        listViewButton.rx.tap
            .subscribe(onNext: { self.discoverVC?.onListViewTapped?(self.viewModel.category) })
            .disposed(by: disposeBag)
        
        let itemSelected = moviesCollectionView.rx.itemSelected
        let modelSelected = moviesCollectionView.rx.modelSelected(Movie.self)
        Observable
            .zip(itemSelected, modelSelected)
            .subscribe(onNext: { indexPath, movie in
                guard let cell = self.moviesCollectionView.cellForItem(at: indexPath) else { return }
                self.discoverVC?.view.isUserInteractionEnabled = false
                
                UIView.animateTap(view: cell, completion: {
                    self.discoverVC?.onMovieTapped?(movie)
                    self.discoverVC?.view.isUserInteractionEnabled = true
                })
            })
            .disposed(by: disposeBag)
        
        moviesCollectionView.rx.willDisplayCell
            .subscribe(onNext: { UIView.animateAppearence(view: $0.cell, dy: -100) })
            .disposed(by: disposeBag)
    }

}

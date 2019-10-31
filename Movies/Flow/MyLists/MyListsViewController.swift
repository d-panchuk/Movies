//
//  MyListsViewController.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

final class MyListsViewController: UIViewController, Storyboarded {

    // MARK: Outlets
    @IBOutlet private weak var listsSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var moviesTableView: UITableView!
    
    // MARK: Properties
    var viewModel: MyListsViewModelType!
    var onMovieDisclosure: ((Movie) -> (Void))?
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSegmentedControl()
        initMoviesTableView()
        initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let listIndex = listsSegmentedControl.selectedSegmentIndex
        updateMoviesWithList(at: listIndex)
    }
    
    // MARK: Private methods
    private func initSegmentedControl() {
        Movie.List.allCases.enumerated().forEach { index, list in
            listsSegmentedControl.setImage(list.image, forSegmentAt: index)
        }
    }
    
    private func initMoviesTableView() {
        moviesTableView.tableFooterView = UIView(frame: .zero)
        moviesTableView.register(
            UINib(nibName: "MyListsMovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: MyListsMovieTableViewCell.reuseIdentifier
        )
    }
    
    private func initBindings() {
        listsSegmentedControl.rx.selectedSegmentIndex
            .skip(1)
            .subscribe(onNext: { self.updateMoviesWithList(at: $0) })
            .disposed(by: disposeBag)
        
        viewModel.movies
            .drive(moviesTableView.rx.items(
                cellIdentifier: MyListsMovieTableViewCell.reuseIdentifier,
                cellType: MyListsMovieTableViewCell.self)
            ) { (_, movie, cell) in
                cell.viewModel = MovieCellViewModel(model: movie)
                cell.onDisclosure = { self.onMovieDisclosure?(movie) }
            }
            .disposed(by: disposeBag)
        
        moviesTableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { self.onMovieDisclosure?($0) })
            .disposed(by: disposeBag)
        
        moviesTableView.rx.modelDeleted(Movie.self)
            .map { ($0, Movie.List(index: self.listsSegmentedControl.selectedSegmentIndex)!) }
            .bind(to: viewModel.movieUnlistTrigger)
            .disposed(by: disposeBag)
        
        moviesTableView.rx.willDisplayCell
            .subscribe(onNext: { UIView.animateAppearence(view: $0.cell, dy: -100) })
            .disposed(by: disposeBag)
    }
    
    private func updateMoviesWithList(at index: Int) {
        guard let list = Movie.List(index: index) else { return }
        listsSegmentedControl.setTitleTextAttributes([.foregroundColor: list.imageColor], for: .selected)
        viewModel.listSwitchTrigger.onNext(list)
    }
    
}

private extension Movie.List {
    
    var image: UIImage {
        let innerImage = UIImage(systemName: filledIconName)!
        return UIImage.textEmbeded(image: innerImage, text: displayableText)
    }
    
    var imageColor: UIColor {
        switch self {
        case .watched: return .systemBlue
        case .favorite: return .systemRed
        case .watchLater: return .systemYellow
        }
    }
    
    init?(index: Int) {
        guard index >= 0, index < Movie.List.allCases.count else {
            return nil
        }
        self = Movie.List.allCases[index]
    }
    
}

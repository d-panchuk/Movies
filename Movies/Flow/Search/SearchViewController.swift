//
//  SearchViewController.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchListContainerView: UIView!
    @IBOutlet private weak var latestSearchesContainerView: UIView!
    @IBOutlet private weak var latestSearchesTableView: UITableView!
    @IBOutlet private weak var latestSearchesClearButton: UIButton!
    
    var moviesListVC: MoviesListViewController!
    var viewModel: SearchMoviesListViewModelType!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latestSearchesTableView.tableFooterView = UIView(frame: .zero)
        setupMoviesListVC()
        initBindings()
    }
    
    private func setupMoviesListVC() {
        addChild(moviesListVC)
        searchListContainerView.addSubview(moviesListVC.view)
        moviesListVC.view.frame = searchListContainerView.bounds
        moviesListVC.didMove(toParent: self)
    }
    
    private func initBindings() {
        viewModel.latestSearches
            .drive(
                latestSearchesTableView.rx.items(
                    cellIdentifier: "DefaultCell",
                    cellType: UITableViewCell.self)
            ) { (_, keyword, cell) in
                cell.textLabel?.textColor = .systemBlue
                cell.textLabel?.text = keyword
            }
            .disposed(by: disposeBag)
        
        latestSearchesClearButton.rx.tap
            .bind(to: viewModel.latestSearchesClearTrigger)
            .disposed(by: disposeBag)
        
        let keywordTyped = searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        let keywordSelectedFromLatest = latestSearchesTableView.rx.modelSelected(String.self)
            .map { $0 }
        
        Observable
            .merge(keywordTyped, keywordSelectedFromLatest)
            .do(onNext: { keyword in self.latestSearchesContainerView.isHidden = !keyword.isEmpty })
            .subscribe(viewModel.keywordUpdateTrigger)
            .disposed(by: disposeBag)
    }

}

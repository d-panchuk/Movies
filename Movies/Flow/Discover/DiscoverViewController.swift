//
//  DiscoverViewController.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class DiscoverViewController: UIViewController, Storyboarded {

    // MARK: Outlets
    @IBOutlet private weak var categorizedMoviesTableView: UITableView!
    
    // MARK: Properties
    var onMovieTapped: ((Movie) -> (Void))?
    var onListViewTapped: ((Movie.Category) -> (Void))?
    
    private var categoryCells: [CategoryTableViewCell] = []
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieCategories: [Movie.Category] = [.nowPlaying, .popular, .upcoming, .topRated]
        categoryCells = movieCategories.map { initCell(of: $0) }.reduce(into: [CategoryTableViewCell](), { $0.append($1)} )
    }
    
    // MARK: Private methods
    private func initCell(of category: Movie.Category) -> CategoryTableViewCell {
        let cell = UINib(nibName: "CategoryTableViewCell", bundle: nil).instantiate(withOwner: self).first as! CategoryTableViewCell
        cell.discoverVC = self
        cell.viewModel = CategoryMoviesListViewModel(category: category)
        return cell
    }
    
}

// MARK: - UITableViewDataSource
extension DiscoverViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return categoryCells[indexPath.section]
    }
    
}

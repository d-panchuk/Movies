//
//  MyListsMovieTableViewCell.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class MyListsMovieTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var releaseYearLabel: UILabel!
    
    var viewModel: MovieCellViewModel! {
        didSet { updateUI() }
    }
    var onDisclosure: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelImageLoading()
    }
    
    private func updateUI() {
        posterImageView.setImage(from: viewModel.poster)
        titleLabel.text = viewModel.title
        releaseYearLabel.text = viewModel.releaseYear
        genresLabel.text = viewModel.genres
    }
    
    @IBAction private func onDisclosureButtonTapped(_ sender: Any) {
        onDisclosure?()
    }
    
}

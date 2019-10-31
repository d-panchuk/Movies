//
//  MovieTableViewCell.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class MovieTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var releaseYearLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    var viewModel: MovieCellViewModel! {
        didSet { updateUI() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.layer.cornerRadius = 20
        posterImageView.layer.cornerRadius = 20
        
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = 6
        container.layer.shadowOpacity = 0.5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelImageLoading()
    }
    
    private func updateUI() {
        posterImageView.setImage(from: viewModel.poster)
        titleLabel.text = viewModel.title
        genresLabel.text = viewModel.genres
        releaseYearLabel.text = viewModel.releaseYear
        ratingLabel.text = viewModel.rating
    }
    
}

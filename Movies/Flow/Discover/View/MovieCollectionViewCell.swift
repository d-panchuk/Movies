//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 20
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelImageLoading()
    }

    func configure(from viewModel: MovieCellViewModel) {
        posterImageView.setImage(from: viewModel.poster)
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rating
    }
    
}

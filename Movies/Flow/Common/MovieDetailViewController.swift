//
//  MovieDetailViewController.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController, Storyboarded {

    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var combinedDescriptionLabel: UILabel!
    @IBOutlet private weak var countriesLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var votesCountLabel: UILabel!
    @IBOutlet private weak var overviewTextView: UITextView!
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var genresStackView: UIStackView!
    @IBOutlet private weak var watchStatusButton: UIButton!
    @IBOutlet private weak var favoriteStatusButton: UIButton!
    @IBOutlet private weak var watchLaterStatusButton: UIButton!
    
    // MARK: Properties
    var viewModel: MovieDetailViewModelType!
    
    private let disposeBag = DisposeBag()
    private var genresStackViewHeightAnchor: NSLayoutConstraint?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genresStackViewHeightAnchor = genresStackView.heightAnchor.constraint(equalToConstant: 0)
        initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: Private methods
    private func initBindings() {
        viewModel.modelDidChange
            .drive(onNext: { [unowned self] in self.updateUI() })
            .disposed(by: disposeBag)
        
        watchStatusButton.rx.tap
            .subscribe(onNext: { [unowned self] in self.viewModel.watchStatusChange.accept(()) })
            .disposed(by: disposeBag)

        favoriteStatusButton.rx.tap
            .subscribe(onNext: { [unowned self] in self.viewModel.favoriteStatusChange.accept(()) })
            .disposed(by: disposeBag)

        watchLaterStatusButton.rx.tap
            .subscribe(onNext: { [unowned self] in self.viewModel.watchLaterStatusChange.accept(()) })
            .disposed(by: disposeBag)
    }
    
    private func updateUI() {
        titleLabel.text = viewModel.title
        combinedDescriptionLabel.text = viewModel.combinedDescription
        countriesLabel.text = viewModel.countries
        ratingLabel.text = viewModel.rating
        votesCountLabel.text = viewModel.votesCount
        overviewTextView.text = viewModel.overview
        
        backdropImageView.setImage(from: viewModel.backdropImagePath)
        updateGenresStackView()
        
        watchStatusButton.setBackgroundImage(viewModel.watchStatusImage, for: .normal)
        favoriteStatusButton.setBackgroundImage(viewModel.favoriteStatusImage, for: .normal)
        watchLaterStatusButton.setBackgroundImage(viewModel.watchLaterStatusImage, for: .normal)
    }
    
    private func updateGenresStackView() {
        genresStackView.subviews.forEach { $0.removeFromSuperview() }
        genresStackViewHeightAnchor?.isActive = (viewModel.genres.count == 0)
        viewModel.genres.forEach { genre in
            let genreLabel = makeGenreLabelFromString(genre)
            genresStackView.addArrangedSubview(genreLabel)
        }
    }
    
    private func makeGenreLabelFromString(_ genre: String) -> UILabel {
        let label = InsetLabel()
        label.text = genre
        label.font = .boldSystemFont(ofSize: 12)
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.contentInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        return label
    }
    
}

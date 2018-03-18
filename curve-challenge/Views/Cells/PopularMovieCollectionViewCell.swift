//
//  PopularMovieCollectionViewCell.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

class PopularMovieCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var favouriteButton: FavouriteButton!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	
	override func prepareForReuse() {
		posterImageView.image = nil
		titleLabel.text = nil
		releaseDateLabel.text = nil
		overviewLabel.text = nil
		ratingLabel.text = nil
		favouriteButton.id = nil
		favouriteButton.setImage(nil, for: .normal)
		activityIndicatorView.isHidden = true
	}
}

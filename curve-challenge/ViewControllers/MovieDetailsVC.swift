//
//  MovieDetailsVC.swift
//  curve-challenge
//
//  Created by Saul Liang on 16/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit
import Lottie

protocol MovieDetailsDelegate: class {
	func movieDetailsChanged(_ updatedMovie: Movie)
}

class MovieDetailsVC: UIViewController {

	@IBOutlet weak var movieDetailsView: UIView!
	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var posterWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
	
	weak var movieDetailsDelegate: MovieDetailsDelegate?
	var movie: Movie?
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
		configureNavigationBar()
		configurePosterImageView()
		updatePosterImageView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		configureMovieDetailsView()
		enableReachabilityManager()
		NotificationCenter.default.addObserver(self, selector: #selector(reloadView),
											   name: .UIDeviceOrientationDidChange, object: nil)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
		super.viewDidDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
	}
	
	// Set navbar title and icon status for favourite state
	private func configureNavigationBar() {
		
		guard let movie = movie else { return }
		let icon = movie.isFavourite ? UIImage.favouriteIcon(.white) : UIImage.favouriteBorderIcon(.white)
		title = movie.title
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain,
															target: self, action: #selector(toggleFavourite))
	}
	
	// Set correct sizing and position for poster image
	private func configurePosterImageView() {
		
		let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
		let maxAvailableHeight = UIScreen.main.bounds.height - navigationBarHeight - 48
		let maxAvailableWidth = UIScreen.main.bounds.width - 48
		posterWidthConstraint.constant = min(maxAvailableWidth, 2/3 * maxAvailableHeight)
		posterHeightConstraint.constant = min(maxAvailableHeight, 3/2 * maxAvailableWidth)
	}
	
	// Add lottie loading animation if image has not been set
	private func configureMovieDetailsView() {
		
		guard posterImageView.image == nil else {
			movieDetailsView.subviews.forEach({ $0.removeFromSuperview() })
			return
		}
		let animationView = LOTAnimationView(name: "simple_loader_purple")
		let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
		animationView.center = CGPoint(x: (UIScreen.main.bounds.height - navigationBarHeight)/2,
									   y: UIScreen.main.bounds.width/2)
		animationView.loopAnimation = true
		animationView.play()
		movieDetailsView.subviews.forEach({ $0.removeFromSuperview() })
		movieDetailsView.addSubview(animationView)
	}
	
	// Use AlamoFireImage to set image to poster image view
	private func updatePosterImageView() {
		
		guard self.posterImageView.image == nil else { return }
		guard let movie = self.movie else { return }
		guard let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + movie.posterPath) else { return }
		self.posterImageView.af_setImage(withURL: posterURL)
	}
	
	// Download movie poster when device regains connection (listener allows auto retry on connection)
	private func enableReachabilityManager() {

		Network.reachabilityManager?.listener = { [weak self] _ in
			guard let strongSelf = self else { return }
			if let isNetworkReachable = Network.reachabilityManager?.isReachable,
				isNetworkReachable == true {
				strongSelf.updatePosterImageView()
			}
		}
	}
	
	// Reconfigure view after device rotation change
	@objc private func reloadView() {
		
		configurePosterImageView()
		configureMovieDetailsView()
	}
	
	// Updates movie with favourite state and stores in UserDefaults
	@objc private func toggleFavourite() {
		
		guard let movie = movie else { return }
		let isFavourite = !movie.isFavourite
		let updatedMovie = Movie(id: movie.id,
								 title: movie.title,
								 releaseDate: movie.releaseDate,
								 overview: movie.overview,
								 voteAverage: movie.voteAverage,
								 posterPath: movie.posterPath,
								 isFavourite: isFavourite)
		self.movie = updatedMovie
		UserDefaults.standard.set(isFavourite, forKey: String(updatedMovie.id))
		configureNavigationBar()
		movieDetailsDelegate?.movieDetailsChanged(updatedMovie)
	}
}

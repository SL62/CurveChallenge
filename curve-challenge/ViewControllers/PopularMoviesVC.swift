//
//  PopularMoviesVC.swift
//  curve-challenge
//
//  Created by Saul Liang on 16/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit
import Lottie

class PopularMoviesVC: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	private var popularMovieCellId = "PopularMovieCell"
	private var footerViewId = "FooterView"
	private var popularMovies: [Movie] = []
	private var resultsPage = 1
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		configureCollectionView()
		fetchMovies()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		enableReachabilityManager()
		NotificationCenter.default.addObserver(self, selector: #selector(reloadView),
											   name: .UIDeviceOrientationDidChange, object: nil)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
		super.viewDidDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
	}
	
	// Set up collection view delegate, datasource, and appearance
	private func configureCollectionView() {
		
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor.groupTableViewBackground
	}
	
	// Re-try updating movies and (visible) movie posters when device regains connection
	private func enableReachabilityManager() {
		
		Network.reachabilityManager?.startListening()
		Network.reachabilityManager?.listener = { [weak self] _ in
			
			guard let strongSelf = self else { return }
			if let isNetworkReachable = Network.reachabilityManager?.isReachable,
				isNetworkReachable == true {
				strongSelf.collectionView.reloadData()
			}
		}
	}

	// Fetch next batch of movies based on TMDb API page number
	private func fetchMovies() {
		
		DispatchQueue.global(qos: .background).async {
			Network.getPopularMovies(forPage: String(self.resultsPage)) { movies in
				guard let firstMovie = movies.first else { return }
				guard !self.popularMovies.contains(where: { $0.id == firstMovie.id })  else { return }
				DispatchQueue.main.async {
					self.popularMovies += movies
					self.collectionView.reloadData()
					self.resultsPage += 1
				}
			}
		}
	}
	
	// Reset collection view after device rotation
	@objc private func reloadView() {
		self.collectionView.reloadData()
	}
	
	// Updates movie with favourite state and stores in UserDefaults
	@objc private func toggleFavourite(sender: FavouriteButton) {
		
		guard let id = sender.id else { return }
		guard let index = popularMovies.index(where: { $0.id == id }) else { return }
		let indexPath = IndexPath(item: index, section: 0)
		
		let movie = popularMovies[index]
		let isFavourite = !movie.isFavourite
		let updatedMovie = Movie(id: movie.id,
								 title: movie.title,
								 releaseDate: movie.releaseDate,
								 overview: movie.overview,
								 voteAverage: movie.voteAverage,
								 posterPath: movie.posterPath,
								 isFavourite: isFavourite)
		popularMovies[index] = updatedMovie
		collectionView.reloadItems(at: [indexPath])
		UserDefaults.standard.set(isFavourite, forKey: String(updatedMovie.id))
	}
}

extension PopularMoviesVC: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView,
						didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		guard popularMovies.indices.contains(indexPath.item) else { return }
		let movie = popularMovies[indexPath.item]
		let movieDetailsVC = UIStoryboard.loadMovieDetailsVC()
		movieDetailsVC.movie = movie
		movieDetailsVC.movieDetailsDelegate = self
		navigationController?.show(movieDetailsVC, sender: self)
	}
	
	func collectionView(_ collectionView: UICollectionView,
						willDisplay cell: UICollectionViewCell,
						forItemAt indexPath: IndexPath) {
		guard Network.reachabilityManager?.isReachable ?? false else { return }
		if indexPath.item == popularMovies.count - 1 {
			fetchMovies()
		}
	}
}

extension PopularMoviesVC: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: UIScreen.main.bounds.width - 24, height: 184)
	}
}

extension PopularMoviesVC: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if popularMovies.isEmpty {
			collectionView.backgroundView = collectionView.loadingMoviesBackground()
			return 0
		} else {
			collectionView.backgroundView = nil
			return 1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		return popularMovies.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularMovieCellId,
													  for: indexPath) as! PopularMovieCollectionViewCell
		
		guard popularMovies.indices.contains(indexPath.item) else { return cell }
		let movie = popularMovies[indexPath.item]
		guard let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + movie.posterPath) else { return cell }
		let voteAverageString = NSMutableAttributedString(string: String(Int(movie.voteAverage * 10)),
														  attributes: [NSAttributedStringKey.font: UIFont.medium(16)])
		let percetageString = NSAttributedString(string: "%", attributes: [NSAttributedStringKey.font: UIFont.medium(10)])
		voteAverageString.append(percetageString)
		
		cell.titleLabel.text = movie.title
		cell.releaseDateLabel.text = movie.releaseDate.getFormattedLabel()
		cell.overviewLabel.text = movie.overview
		cell.ratingLabel.attributedText = voteAverageString
		cell.ratingLabel.textColor = .voteAverageColor(forRating: movie.voteAverage)
		if movie.isFavourite {
			cell.favouriteButton.setImage(.favouriteIcon, for: .normal)
			cell.favouriteButton.tintColor = .pink
		} else {
			cell.favouriteButton.setImage(.favouriteBorderIcon, for: .normal)
			cell.favouriteButton.tintColor = .lightGray
		}
		cell.favouriteButton.id = movie.id
		cell.favouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
		cell.posterImageView.af_setImage(withURL: posterURL)
		cell.activityIndicatorView.isHidden = cell.posterImageView.image == nil ? false : true
		cell.activityIndicatorView.startAnimating()
		
		cell.selectedBackgroundView = cell.defaultSelectedBackgroundView()
		cell.selectedBackgroundView?.layer.cornerRadius = 8
		cell.selectedBackgroundView?.layer.masksToBounds = true
		cell.contentView.layer.cornerRadius = 8
		cell.contentView.layer.borderWidth = 0.5
		cell.contentView.layer.borderColor = UIColor.clear.cgColor
		cell.contentView.layer.masksToBounds = true
		cell.layer.shadowColor = UIColor.gray.cgColor
		cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		cell.layer.shadowRadius = 1.0
		cell.layer.shadowOpacity = 0.4
		cell.layer.masksToBounds = false
		cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds,
											 cornerRadius: cell.contentView.layer.cornerRadius).cgPath
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView,
						viewForSupplementaryElementOfKind kind: String,
						at indexPath: IndexPath) -> UICollectionReusableView {
		
		let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																		 withReuseIdentifier: footerViewId,
																		 for: indexPath)
		let animationView = LOTAnimationView(name: "simple_loader_purple")
		animationView.center = CGPoint(x: footerView.bounds.size.width/2, y: footerView.bounds.size.height/2)
		animationView.loopAnimation = true
		animationView.play()
		footerView.subviews.forEach({ $0.removeFromSuperview() })
		footerView.addSubview(animationView)
		return footerView
	}
}

extension PopularMoviesVC: MovieDetailsDelegate {
	
	// Update movie following change to favourite state on movie details page
	func movieDetailsChanged(_ updatedMovie: Movie) {
		
		guard let index = popularMovies.index(where: { $0.id == updatedMovie.id }) else { return }
		let indexPath = IndexPath(item: index, section: 0)
		popularMovies[index] = updatedMovie
		collectionView.reloadItems(at: [indexPath])
	}
}

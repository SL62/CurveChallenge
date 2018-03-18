//
//  Network.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class Network {
	
	private init() {}
	
	static let apiKey = "<<<INSERT API KEY>>>"
	static let reachabilityManager = NetworkReachabilityManager()
	static let imageCache = AutoPurgingImageCache()
	
	// Returns array of movies for given TMDb API page number
	static func getPopularMovies(forPage page: String,
								 completion: @escaping (_ movies: [Movie]) -> Void) {
		
		Alamofire.request("https://api.themoviedb.org/3/movie/popular?api_key=" + apiKey + "&page=" + page,
						  method: .get,
						  encoding: JSONEncoding.default)
			
			.responseJSON { response in
				
				switch response.result {
				case .success:
					
					guard let responseValue = response.result.value as? [String: Any] else {
						completion([])
						return
					}
					guard let results = responseValue["results"] as? [[String: Any]] else {
						completion([])
						return
					}
					
					var movies: [Movie] = []
					for result in results {
						guard let id = result["id"] as? Int else { continue }
						guard let title = result["title"] as? String else { continue }
						guard let releaseDateString = result["release_date"] as? String else { continue }
						guard let releaseDate = releaseDateString.getDate() else { continue }
						guard let overview = result["overview"] as? String else { continue }
						guard let voteAverage = result["vote_average"] as? Double else { continue }
						guard let posterPath = result["poster_path"] as? String else { continue }
						let isFavourite = UserDefaults.standard.bool(forKey: String(id))
						
						let movie = Movie(id: id,
										  title: title,
										  releaseDate: releaseDate,
										  overview: overview,
										  voteAverage: voteAverage,
										  posterPath: posterPath,
										  isFavourite: isFavourite)
						movies.append(movie)
					}
					completion(movies)
					
				case .failure(let error):
					print("[Network] Error: \(error.localizedDescription)")
					completion([])
				}
		}
	}
}

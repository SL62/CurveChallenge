//
//  Movie.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

struct Movie {
	
	let id: Int
	let title: String
	let releaseDate: Date
	let overview: String
	let voteAverage: Double
	let posterPath: String
	var isFavourite: Bool
}

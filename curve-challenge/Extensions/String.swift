//
//  String.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import Foundation

extension String {
	
	func getDate() -> Date? {
		
		Utility.dateFormatter.calendar = Calendar.current
		Utility.dateFormatter.dateFormat = "yyyy-MM-dd"
		return Utility.dateFormatter.date(from: self)
	}
}

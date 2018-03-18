//
//  Date.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import Foundation

extension Date {
	
	func getFormattedLabel() -> String {
		
		Utility.dateFormatter.calendar = Calendar.current
		Utility.dateFormatter.dateFormat = "MMMM d, yyyy"
		return Utility.dateFormatter.string(from: self)
	}
}

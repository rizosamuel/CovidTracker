//
//  Extension.swift
//  CovidTracker
//
//  Created by Rijo Samuel on 06/02/22.
//

import Foundation

extension DateFormatter {
	
	static let dayFormatter: DateFormatter = {
		
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-dd"
		formatter.timeZone = .current
		formatter.locale = .current
		return formatter
	}()
	
	static let prettyFormatter: DateFormatter = {
		
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.dateFormat = "YYYY-MM-dd"
		formatter.timeZone = .current
		formatter.locale = .current
		return formatter
	}()
}

extension NumberFormatter {
	
	static let numFormatter: NumberFormatter = {
		
		let formatter = NumberFormatter()
		formatter.locale = .current
		return formatter
	}()
}

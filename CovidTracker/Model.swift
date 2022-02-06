//
//  Model.swift
//  CovidTracker
//
//  Created by Rijo Samuel on 06/02/22.
//

import Foundation

struct StatesResponse: Codable {
	let data: [State]
}

struct State: Codable {
	
	let name: String
	let state_code: String
}

struct CovidDataResponse: Codable {
	let data: [CovidDayData]
}

struct CovidDayData: Codable {
	
	let cases: CovidCases?
	let date: String
}

struct CovidCases: Codable {
	let total: TotalCases?
}

struct TotalCases: Codable {
	let value: Int?
}

struct DayData: Codable {
	
	let date: Date
	let count: Int
}

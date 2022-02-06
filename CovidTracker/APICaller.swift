//
//  APICaller.swift
//  CovidTracker
//
//  Created by Rijo Samuel on 06/02/22.
//

import Foundation

final class APICaller {
	
	static let shared = APICaller()
	
	private init() {}
	
	private struct Constants {
		static let baseUrl = "https://api.covidtracking.com/v2"
		static let allStatesUrl = "https://api.covidtracking.com/v2/states.json"
		static let covidStateDataUrl = "https://api.covidtracking.com/v2/states/ca/daily.json"
	}
	
	enum DataScope {
		case national
		case state(State)
	}
	
	func getCovidData(for scope: DataScope, completion: @escaping (Result<[DayData], Error>) -> Void) {
		
		let urlString: String
		
		switch scope {
			case .national: urlString = "https://api.covidtracking.com/v2/us/daily.json"
			case .state(let state): urlString = "\(Constants.baseUrl)/states/\(state.state_code.lowercased())/daily.json"
		}
		
		guard let url = URL(string: urlString) else { return }
		
		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			
			guard let data = data, error == nil else { return }
			
			do {
				let result = try JSONDecoder().decode(CovidDataResponse.self, from: data)
				
				let daydata = result.data.compactMap {
					DayData(
						date: DateFormatter.dayFormatter.date(from: $0.date) ?? .now,
						count: $0.cases?.total?.value ?? 0
					)
				}
				
				DispatchQueue.main.async { completion(.success(daydata)) }
			} catch {
				print(error.localizedDescription)
			}
		}
		
		task.resume()
	}
	
	func getStateList(completion: @escaping (Result<[State], Error>) -> Void) {
		
		guard let url = URL(string: Constants.allStatesUrl) else { return }
		
		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			
			guard let data = data, error == nil else { return }
			
			do {
				let result = try JSONDecoder().decode(StatesResponse.self, from: data)
				DispatchQueue.main.async { completion(.success(result.data)) }
			} catch {
				print(error.localizedDescription)
			}
		}
		
		task.resume()
	}
}

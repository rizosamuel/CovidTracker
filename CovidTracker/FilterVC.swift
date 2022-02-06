//
//  FilterVC.swift
//  CovidTracker
//
//  Created by Rijo Samuel on 06/02/22.
//

import UIKit

class FilterVC: UIViewController {
	
	private let tableView: UITableView = {
		
		let table = UITableView(frame: .zero, style: .grouped)
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return table
	}()
	
	var callback: ((State) -> Void)?
	
	private var states: [State] = []
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		title = "Select State"
		view.backgroundColor = .systemBackground
		
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		
		createBarButtonItem()
		fetchStates()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}
	
	private func fetchStates() {
		
		APICaller.shared.getStateList { [weak self] result in
			
			switch result {
					
				case .success(let states):
					self?.states = states
					self?.tableView.reloadData()
					
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}
	
	private func createBarButtonItem() {
		
		navigationItem.rightBarButtonItem =
		UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
	}
	
	@objc private func didTapClose() {
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - Table View Delegate Methods
extension FilterVC: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return states.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = states[indexPath.row].name
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		callback?(states[indexPath.row])
		dismiss(animated: true, completion: nil)
	}
}

//
//  ViewController.swift
//  CovidTracker
//
//  Created by Rijo Samuel on 06/02/22.
//

import UIKit
import Charts

class ViewController: UIViewController {
	
	private let tableView: UITableView = {
		
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return table
	}()
	
	private var scope: APICaller.DataScope = .national
	
	private var dayDatas: [DayData] = []

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		title = "Covid Cases"
		
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		
		createFilterButton()
		fetchData()
	}
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}

	private func createFilterButton() {
		
		let buttonTitle: String = {
			
			switch self.scope {
				case .national: return "National"
				case .state(let state): return state.name
			}
		}()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(didTapFilter))
	}
	
	@objc private func didTapFilter() {
		
		let vc = FilterVC()
		
		vc.callback = { [weak self] state in
			
			self?.scope = .state(state)
			self?.fetchData()
			self?.createFilterButton()
		}
		
		present(UINavigationController(rootViewController: vc), animated: true)
	}
	
	private func fetchData() {
		
		APICaller.shared.getCovidData(for: scope) { [weak self] result in
			
			switch result {
					
				case .success(let dayDatas):
					self?.dayDatas = dayDatas
					self?.tableView.reloadData()
					self?.createGraph()
					
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}
	
	private func createGraph() {
		
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 2))
		headerView.clipsToBounds = true
		let chart = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 2))
		
		var entries: [BarChartDataEntry] = []
		
		let set = dayDatas.prefix(20)
		
		for (index, element) in set.enumerated() {
			entries.append(.init(x: Double(index), y: Double(element.count)))
		}
		
		let dataSet = BarChartDataSet(entries: entries)
		dataSet.colors = ChartColorTemplates.joyful()
		let data = BarChartData(dataSet: dataSet)
		chart.data = data
		headerView.addSubview(chart)
		tableView.tableHeaderView = headerView
	}
}

// MARK: - Table View Delegate Methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dayDatas.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = createText(with: dayDatas[indexPath.row])
		return cell
	}
	
	private func createText(with data: DayData) -> String? {
		
		let dateString = DateFormatter.prettyFormatter.string(from: data.date)
		let total = NumberFormatter.numFormatter.string(from: NSNumber(value: data.count)) ?? data.count.description
		return "\(dateString): \(total)"
	}
}

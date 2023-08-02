//
//  WeatherListViewController.swift
//  Project2
//
//  Created by Aman Giri on 2023-08-01.
//

import UIKit

class WeatherListViewController: UIViewController, UITableViewDataSource {
    
    
    var weatherList: [Weather] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(weatherList)
        tableView.dataSource = self
        for weather1 in weatherList {
            print(weather1.cityName)
            
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityWeatherCells", for: indexPath)
        
        let weather = weatherList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = weather.cityName
        content.secondaryText = weather.tempInC
        content.image = UIImage(systemName: "magnifyingglass")

        cell.contentConfiguration = content
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
    
}


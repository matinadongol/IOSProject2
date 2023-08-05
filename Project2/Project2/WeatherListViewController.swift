//
//  WeatherListViewController.swift
//  Project2
//
//  Created by Aman Giri on 2023-08-01.
//

import UIKit

class WeatherListViewController: UIViewController, UITableViewDataSource {

    var weatherList: [Weather] = []
    var selectedTemperature: Int?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityWeatherCells", for: indexPath)
        
        let weather = weatherList[indexPath.row]
        let weatherCode = weather.weatherCode
        
        var content = cell.defaultContentConfiguration()
        content.text = weather.cityName
        if(selectedTemperature == 0){
            content.secondaryText = "Temperature: \(weather.tempInC)°C"
        }else{
            content.secondaryText = "Temperature: \(weather.temInF)°F"
        }
        content.image = weatherIconDictionary[weatherCode]?.generateDayImage()

        cell.contentConfiguration = content
        
        return cell
    }
    
}


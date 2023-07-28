//
//  ViewController.swift
//  Project2
//
//  Created by Matina Dongol on 2023-07-28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchInput: UITextField!
    let apiKey = "89221bdc6a8c451a9a8212939232807"
    let baseURL = "http://api.weatherapi.com/v1/current.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchButtonImage = UIImage(systemName: "magnifyingglass")
        searchButton.setImage(searchButtonImage, for: .normal)
        let locationButtonImage = UIImage(systemName: "location.fill")
        locationButton.setImage(locationButtonImage, for: .normal)
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemYellow])
        self.weatherImage.preferredSymbolConfiguration = config
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        let searchValue = searchInput.text
        if let anything = searchValue{
            print("search:  \(String(describing: searchValue))")
            fetchWeather(searchValue: searchValue!)
        }
    }

    
    func fetchWeather(searchValue: String){
        guard !searchValue.isEmpty else {return}
        
        let url = URL( string: "\(baseURL)?key=\(apiKey)&q=\(searchValue)")!
        
        print("\(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                            DispatchQueue.main.async {
                                print(weatherResponse)
                                self.updateUI(with: weatherResponse.weatherData)
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }.resume()
        
    }
    
    private func updateUI(with weatherData: WeatherData) {
//            locationLabel.text = "\(weatherData.location.name), \(weatherData.location.region)"
//            conditionLabel.text = weatherData.current.condition.text
//            temperatureLabel.text = "\(weatherData.current.tempC)°C"
        print(" \(weatherData.location.name)")
        }
    
}


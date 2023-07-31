//
//  ViewController.swift
//  Project2
//
//  Created by Matina Dongol on 2023-07-28.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var lblWeatherDescription: UILabel!
    let apiKey = "89221bdc6a8c451a9a8212939232807"
    let baseURL = "http://api.weatherapi.com/v1/current.json"
    var selectedSegmentIndex: Int = 0
    var locationName = "london"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeather(searchValue: locationName)
        
        let searchButtonImage = UIImage(systemName: "magnifyingglass")
        searchButton.setImage(searchButtonImage, for: .normal)
        let locationButtonImage = UIImage(systemName: "location.fill")
        locationButton.setImage(locationButtonImage, for: .normal)
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemYellow])
        self.weatherImage.preferredSymbolConfiguration = config
        lblCityName.text = locationName
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        let searchValue = searchInput.text
        if let search = searchValue {
            print("search:  \(String(describing: search))")
            fetchWeather(searchValue: search)
            print("locaitonName: \(locationName)")
            
        }
    }
    
    
    func setUI(locationData: LocationWrapper){
        locationName = locationData.location.name
        print("\(locationName)")
//        lblTemperature.text = String(locationData.current.temp_f)
    }
    
    struct LocationWrapper: Decodable{
        let location: Location
        let current: Current
    }

    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
        let lat: Float
        let lon: Float
    }

    struct Current: Decodable {
        let temp_c: Float
        let temp_f: Float
        let condition: Condition
    }

    struct Condition: Decodable {
        let text: String
        let icon: String
        let code: Int
    }
    
    func parseJson (data: Data) -> LocationWrapper?{
        let decoder = JSONDecoder()
        var wrapper: LocationWrapper?
        
        do{
            wrapper = try decoder.decode(LocationWrapper.self, from: data)
            
        }catch{
            print(error)
        }
        return wrapper
    }
    
    @IBAction func selectedTempType(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        print("Selected segment index: \(selectedSegmentIndex)")
    }
    
    func fetchWeather(searchValue: String) {
        guard !searchValue.isEmpty else {return}
        
        let url: URL? = URL( string: "\(baseURL)?key=\(apiKey)&q=\(searchValue)")!
        let urlSession = URLSession(configuration: .default)
        
        if let url = url {
            let dataTask = urlSession.dataTask(with: url) {
                data, response, error in
                
                guard error == nil else {
                    print (error ?? "")
                    return
                }
                
                guard let data = data else {
                    print("No data")
                    return
                }
                
                if let locationData = self.parseJson(data: data){
                    print(locationData)
                    self.setUI(locationData: locationData)
                }
            }
            dataTask.resume()
        }
    }
    
}
  
    


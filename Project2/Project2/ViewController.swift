//
//  ViewController.swift
//  Project2
//
//  Created by Matina Dongol on 2023-07-28.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemp_C: UILabel!
    @IBOutlet weak var lblTemp_F: UILabel!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var btnCities: UIButton!
    
    let apiKey = "89221bdc6a8c451a9a8212939232807"
    let baseURL = "http://api.weatherapi.com/v1/current.json"
    var selectedSegmentIndex: Int = 0
    var locationName = ""
    var tempInC: String = ""
    var tz_id: String = ""
    var tempInF: String = ""
    var tempSelectedIndex: Int = 0
    var locationManager: CLLocationManager!
    var count = 0
    var weatherList: [Weather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        DispatchQueue.main.async{
            self.setLocation()
        }
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
        let tz_id: String
    }

    struct Current: Decodable {
        let temp_c: Float
        let temp_f: Float
        let condition: Condition
        let is_day: Int
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
    
    @IBAction func citiesButton(_ sender: Any) {
        performSegue(withIdentifier: "weatherListScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "weatherListScreen" {
                let destinationVC = segue.destination as! WeatherListViewController
                destinationVC.weatherList = weatherList
                destinationVC.selectedTemperature = tempSelectedIndex
                }
            }
    
    @IBAction func switchTemperature(_ sender: Any) {
        let selectedSegment = (sender as AnyObject).selectedSegmentIndex
        for list in weatherList{
            print("list: \(list.cityName)")
        }
        if selectedSegment == 1 {
            lblTemp_C.isHidden = true
            lblTemp_F.isHidden = false
        } else if selectedSegment == 0 {
            lblTemp_C.isHidden = false
            lblTemp_F.isHidden = true
        }
        tempSelectedIndex = selectedSegment ?? 0
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        let searchValue = searchInput.text
        if let search = searchValue {
            if search != ""{
                let trimmedSearch = search.replacingOccurrences(of: " ", with: "")
                print(trimmedSearch)
                fetchWeather(searchValue: trimmedSearch)
            }
            else{
                print("Empty Search")
            }
        }
    }
    
    @IBAction func locationButton(_ sender: Any) {
        setLocation()
    }

    func fetchWeather(searchValue: String) {
        guard !searchValue.isEmpty else {
            return
        }
        
        let url: URL? = URL( string: "\(baseURL)?key=\(apiKey)&q=\(searchValue)")
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
                    DispatchQueue.main.async{
                        self.setUI(data: locationData)
                        let weatherObj = Weather(cityName: locationData.location.name, tempInC: String(locationData.current.temp_c), tempInF: String(locationData.current.temp_f), weatherCode: locationData.current.condition.code, tz_id: locationData.location.tz_id)
                        var counter = 0
                        if self.count >= 1{
                            for weather in self.weatherList{
                                let tz_id = weather.tz_id
                                let name = weather.cityName
                                if(tz_id == locationData.location.tz_id && name == locationData.location.name){
                                    counter = 1
                                    print("Location already searched")
                                    break
                                }
                            }
                            if counter != 1{
                                self.weatherList.append(weatherObj)
                                print("Location added")
                            }
                        } else {
                            self.weatherList.append(weatherObj)
                            self.count += 1
                        }
                        print("Array: \(self.weatherList)")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func setLocation(){
        if (self.locationManager.location != nil){
            let location: CLLocationCoordinate2D = self.locationManager.location!.coordinate
            self.locationName = "\(location.latitude),\(location.longitude)"
            DispatchQueue.main.async{
                self.fetchWeather(searchValue: self.locationName)
            }
        }else{
            self.fetchWeather(searchValue: self.locationName)
        }
    }
    
    func setUI(data: LocationWrapper){
        DispatchQueue.main.async{
            
            let searchButtonImage = UIImage(systemName: "magnifyingglass")
            self.searchButton.setImage(searchButtonImage, for: .normal)
            let locationButtonImage = UIImage(systemName: "location.fill")
            self.locationButton.setImage(locationButtonImage, for: .normal)
            let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemYellow])
            self.weatherImage.preferredSymbolConfiguration = config
            self.lblCityName.text = self.locationName
            self.lblTemp_F.isHidden = true
            
            
            self.lblCityName.text = data.location.name
            self.lblWeatherDescription.text = data.current.condition.text
            self.lblTemp_C.text = String(data.current.temp_c) + " °C"
            self.lblTemp_F.text = String(data.current.temp_f) + " °F"
            self.tz_id = data.location.tz_id

            let weatherCode = data.current.condition.code
                                
            let nightBackgroundColor = UIColor(red: 0.09, green: 0.129, blue: 0.2, alpha: 1.00)
            let dayBackgroundColor = UIColor(red: 0.667, green: 0.945, blue: 1, alpha: 1.00)
            let nightTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
            let dayTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.00)
            let yellowColor = UIColor(red: 0.96, green: 0.78, blue: 0, alpha: 1.00)
            
            if (data.current.is_day == 1) {
                var dayColorsConfig = UIImage.SymbolConfiguration(paletteColors: [.white, yellowColor])
                if(weatherCode == 1000 ){
                    dayColorsConfig = UIImage.SymbolConfiguration(paletteColors: [yellowColor, yellowColor])
                }
                self.weatherImage.preferredSymbolConfiguration = dayColorsConfig
                self.weatherImage.image = weatherIconDictionary[weatherCode]?.generateDayImage()
                self.view.backgroundColor = dayBackgroundColor
                self.lblCityName.textColor = dayTextColor
                self.lblWeatherDescription.textColor = dayTextColor
                self.lblTemp_C.textColor = dayTextColor
                self.lblTemp_F.textColor = dayTextColor
                self.btnCities.tintColor = dayTextColor
            }
            else if (data.current.is_day == 0) {
                let nightColorsConfig = UIImage.SymbolConfiguration(paletteColors: [.gray, .white])
                self.weatherImage.preferredSymbolConfiguration = nightColorsConfig
                self.weatherImage.image = weatherIconDictionary[weatherCode]?.generateNightImage()
                self.view.backgroundColor = nightBackgroundColor
                self.lblCityName.textColor = nightTextColor
                self.lblWeatherDescription.textColor = nightTextColor
                self.lblTemp_C.textColor = nightTextColor
                self.lblTemp_F.textColor = nightTextColor
                self.btnCities.tintColor = nightTextColor
            }
        }
    }
}


  
    


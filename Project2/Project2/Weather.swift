//
//  File.swift
//  Project2
//
//  Created by Matina Dongol on 2023-08-02.
//

import Foundation

class Weather {
    var cityName: String
    var tempInC: String
    var temInF: String
    var weatherCode: Int
    var tz_id: String
    
    init(cityName: String, tempInC: String, tempInF: String, weatherCode: Int, tz_id: String){
        self.cityName = cityName
        self.tempInC = tempInC
        self.temInF = tempInF
        self.weatherCode = weatherCode
        self.tz_id = tz_id
    }
}

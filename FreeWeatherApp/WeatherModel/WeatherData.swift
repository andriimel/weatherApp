//
//  WeatherData.swift
//  WeatherFree
//
//  Created by Andrii Melnyk on 4/22/24.
//

import Foundation
    
struct WeatherResponse: Codable {
    let resolvedAddress : String
    let description : String
    let days: [Days]
    let currentConditions : CurrentConditions
    //let icon: String
}
struct Days: Codable{
    let datetime: String
    let tempmax: Double
    let tempmin: Double
    let temp: Double
    let icon: String
    let hours: [Hours]
    
}
struct Hours : Codable {
    
    let datetime: String
    let temp: Double
    let icon: String
    }

struct CurrentConditions: Codable {
    
    let temp: Double
    let feelslike: Double
}




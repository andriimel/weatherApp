//
//  WFErrorType.swift
//  WeatherFree
//
//  Created by Andrii Melnyk on 4/22/24.
//

import Foundation

enum FWErrorType: String,Error {
    
    case networkIssue = "You have some problems with your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    
}

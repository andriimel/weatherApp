//
//  WeatherManager.swift
//  WeatherFree
//
//  Created by Andrii Melnyk on 4/22/24.
//

import Foundation

class FWNetworkManager {
    
    static let shared = FWNetworkManager()
    let myAPIkey = "key=79SBXX7Z2R44HQQP5DP7ZEQUT&content"
    
    func getApiData (with location:String,with metric: String, completed:@escaping (Result< WeatherResponse, Error>) -> (Void)) {
        
        let urlString =
        "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(location)?unitGroup=\(metric)&key=79SBXX7Z2R44HQQP5DP7ZEQUT&contentType=json"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completed(.failure(FWErrorType.networkIssue))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(FWErrorType.networkIssue))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(FWErrorType.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(FWErrorType.networkIssue))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(WeatherResponse.self, from: data)
                
                completed(.success(jsonData))
            } catch {
                completed(.failure(FWErrorType.networkIssue))
            }
        }
        task.resume()
    }


}

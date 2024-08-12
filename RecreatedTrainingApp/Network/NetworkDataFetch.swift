//
//  NetworkDataFetch.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 09.08.2023.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init(){}
    
    func fetchWeather(response: @escaping (WeatherModel?, Error?) -> Void){
        NetworkRequest.shared.requestData { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    response(weather, nil)
                } catch let jsonError {
                    print("Failed to decode JSON ", jsonError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil, error)
            }
        }
    }
    
}

//
//  NetworkRequest.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 08.08.2023.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init(){}
    
    func requestData(completion: @escaping (Result<Data, Error>) -> Void){
        let key = "ba8fdec00ed3c3665c13b881693f6032"
        let latitude = 59.933880
        let longitude = 30.337239
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume() //чтобы запустить задачу
    }
}

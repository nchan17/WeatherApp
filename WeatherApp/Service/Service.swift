//
//  Service.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import Foundation

class Service {
    
    private let apiKey = "cbdd233385e363394315c521d7b568d9"
    private let units = "metric"
    private var componentsCurrent = URLComponents()
    private var componentsForecast = URLComponents()
    
    init() {
        componentsCurrent.scheme = "https"
        componentsCurrent.host = "api.openweathermap.org"
        componentsCurrent.path = "/data/2.5/weather"
        
        componentsForecast.scheme = "https"
        componentsForecast.host = "api.openweathermap.org"
        componentsForecast.path = "/data/2.5/forecast"
        
    }
    
    func loadCurrentWeather(cityName : String, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> ()){
        let trimmedCityName = cityName.components(separatedBy: .whitespaces).first!
        
        let parameters = [
            "appid": apiKey.description,
            "q": trimmedCityName,
            "units": units
        ]
        
        componentsCurrent.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        if let url = componentsCurrent.url {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(CurrentWeatherResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(ServiceError.noData))
                }
            })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParameters))
            
        }
    }
    
    func loadForecastFive(cityName : String, completion: @escaping (Result<[Forecast], Error>) -> ()){
        let trimmedCityName = cityName.components(separatedBy: .whitespaces).first!
        
        let parameters = [
            "appid": apiKey.description,
            "q": trimmedCityName,
            "units": units
        ]
        
        componentsForecast.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        if let url = componentsForecast.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(ForecastFiveResponse.self, from: data)
                        completion(.success(result.list))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(ServiceError.noData))
                }
            })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParameters))
        }
        
    }
    
    func getImgUrl(id: String) -> URL {
        return URL(string: "https://openweathermap.org/img/wn/" + id + "@2x.png")!
    }
}


enum ServiceError: Error {
    case noData
    case invalidParameters
}

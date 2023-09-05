//
//  NetworkManager.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 10.08.2023.
//

import Foundation

class NetworkManager {
    
    // MARK: - Singleton property
    
    static let shared = NetworkManager()
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Fetch methods
    
    func fetch<T: Decodable>(_ type: T.Type,
                             _ API: API.RawValue,
                            completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: API)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? NetworkError.noDescription)
                return
            }
            let decoder = JSONDecoder()
            do {
                let type = try decoder.decode(T.self, from: data)
                completion(.success(type))
            } catch let error {
                completion(.failure(.decodingError))
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchQuery<T: Decodable>(by id: Int,
                                  _ type: T.Type,
                                  _ item: QueryItem.RawValue,
                                  _ API: API.RawValue,
                                  completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: API)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: item, value: "\(id)")]
        
        guard let queryURL = components?.url else {
            completion(.failure(.invalidQueryURL))
            return
        }
        
        URLSession.shared.dataTask(with: queryURL) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? NetworkError.noDescription)
                return
            }
            let decoder = JSONDecoder()
            do {
                let type = try decoder.decode(T.self, from: data)
                completion(.success(type))
            } catch let error {
                completion(.failure(.decodingError))
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: - Post method
    
    func request<T: Codable>(_ type: T,
                             _ API: API.RawValue,
                             _ httpMethod: HTTPMethod.RawValue,
                             _ item: QueryItem.RawValue,
                             completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: API)
        
        let sentData = try? JSONEncoder().encode(type)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: HTTPHeader.type.rawValue)
        request.httpBody = sentData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204 else {
                completion(.failure(.noResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                completion(.success(type))
                print(type)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

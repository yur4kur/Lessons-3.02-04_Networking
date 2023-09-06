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
    
    // MARK: - Get requests
    
    func fetch<T: Decodable>(_ type: T.Type,
                             API: API,
                             completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: API.rawValue)
        
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
                                  API: API,
                                  completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: API.rawValue)
        
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
    
    // MARK: - Post request
    
    func postRequest<T: Codable>(_ type: T,
                                 API: API,
                                 _ completion: @escaping (Result<T, NetworkError>) -> Void){
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: API.rawValue)
        
        let sentData = try? JSONEncoder().encode(type)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = sentData
        request.addValue("application/json",
                         forHTTPHeaderField: HTTPHeader.type.rawValue)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                    response.statusCode == 201 else {
                completion(.failure(.noResponse))
                print(error?.localizedDescription ?? NetworkError.noDescription)
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? NetworkError.noDescription)
                return
            }
            do{
                let returnedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(returnedData))
            } catch let error {
                completion(.failure(.decodingError))
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: - Delete request
    
    func deleteRequest<T: Codable>(_ type: T,
                                   API: API,
                                   _ completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: API.rawValue)
        
        let deletedData = try? JSONEncoder().encode(type)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.httpBody = deletedData
        request.addValue("application/json",
                         forHTTPHeaderField: HTTPHeader.type.rawValue)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 || response.statusCode == 204 else {
                completion(.failure(.noResponse))
                print(error?.localizedDescription ?? "Response error")
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? NetworkError.noDescription)
                return
            }
            do {
                let deletedPost = try JSONDecoder().decode(T.self, from: data)
                completion(.success(deletedPost))
                print(deletedPost)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

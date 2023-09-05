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
    
    // MARK: - Public methods
    
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
}

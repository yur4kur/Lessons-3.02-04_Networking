//
//  NetworkManager.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 10.08.2023.
//

import Foundation

// MARK: - Network settings

enum URLs: String {
    case base = "https://jsonplaceholder.typicode.com/"
}

enum APIs: String {
    case users
    case posts
    case comments
}


enum HTTPHeaders: String {
    case length = "Content-Length"
    case type = "Content-Type"
}

enum HTTPMethod: String {
    case post
    case delete
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case noResponse
    case decodingError
    case noDescription
}

// MARK: - Network manager
class NetworkManager {
    
    // MARK: Singleton property
    static let shared = NetworkManager()
    
    // MARK: Initializer
    private init() {}
    
    // MARK: Public methods
    func fetch<T: Decodable>(_ type: T.Type,
                               completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        guard var url = URL(string: URLs.base.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        url.append(path: APIs.users.rawValue)
        
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
}

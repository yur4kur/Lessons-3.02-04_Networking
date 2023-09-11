//
//  NetworkManager.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 10.08.2023.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    // MARK: - Static property
    
    static let shared = NetworkManager()
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Public methods (GET)
    
    func fetch<T: Decodable>(
        _ type: T.Type,
        API: API,
        completion: @escaping(Result<T, AFError>) -> Void
    ) {
        
        guard var url = URL(string: Link.base.rawValue) else {
            completion(
                .failure(
                    AFError.invalidURL(
                        url: Link.base.rawValue
                    )
                )
            )
            return
        }
        url.append(path: API.rawValue)
        
        AF.request(url)
            .validate()
            .responseDecodable(of: type) { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchQuery<T: Decodable>(
        by id: Int,
        _ type: T.Type,
        queryBy item: QueryItem,
        API: API,
        _ completion: @escaping(Result<T, AFError>) -> Void
    ) {
        
        guard var url = URL(string: Link.base.rawValue) else {
            completion(
                .failure(
                    AFError.invalidURL(
                        url: Link.base.rawValue
                    )
                )
            )
            return
        }
        
        url.append(path: API.rawValue)
        url.append(queryItems: [
            URLQueryItem(
                name: item.rawValue,
                value: "\(id)")
        ]
        )
        
        AF.request(url)
            .validate()
            .responseDecodable(of: type) { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: POST
    
    func postRequest<T: Codable>(
        _ type: T,
        API: API,
        _ completion: @escaping (Result<T, AFError>
        ) -> Void){
        
        guard var url = URL(string: Link.base.rawValue) else {
            completion(
                .failure(
                    AFError.invalidURL(
                        url: Link.base.rawValue
                    )
                )
            )
            return
        }
        url.append(path: API.rawValue)
        
        AF.request(url, method: .post, parameters: type)
            .validate()
            .responseDecodable(of: T.self) { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: DELETE
    
    func deleteRequest<T: Codable>(
        _ type: T,
        API: API,
        _ completion: @escaping(Result<T, AFError>) -> Void
    ) {
        
        guard var url = URL(string: Link.base.rawValue) else {
            completion(
                .failure(
                    AFError.invalidURL(
                        url: Link.base.rawValue
                    )
                )
            )
            return
        }
        url.append(path: API.rawValue)
        
        AF.request(url, method: .delete, parameters: type)
            .validate()
            .responseDecodable(of: T.self) { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

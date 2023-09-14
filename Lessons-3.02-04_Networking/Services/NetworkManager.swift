//
//  NetworkManager.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 10.08.2023.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    // MARK: Static property
    static let shared = NetworkManager()
    
    // MARK: Initializer
    private init() {}
    
    // MARK: GET methods
    func fetch<T: Decodable>(_ type: T.Type,
                             resource: RequestResource,
                             completion: @escaping(Result<T, AFError>) -> Void) {
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
        url.append(path: resource.rawValue)
        
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
    
    // MARK: Fetch with query
    func fetchQuery<T: Decodable>(by id: Int,
                                  _ type: T.Type,
                                  queryBy item: QueryItem,
                                  resource: RequestResource,
                                  _ completion: @escaping(Result<T, AFError>) -> Void) {
        guard var url = URL(string: Link.base.rawValue) else {
            completion(.failure(AFError.invalidURL(url: Link.base.rawValue)))
            return
        }
        url.append(path: resource.rawValue)
        url.append(queryItems: [URLQueryItem(name: item.rawValue,value: "\(id)")])
        
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
    
    // MARK: Fetch with responseJP
    func fetchContractors(resource: RequestResource,
                          _ completion: @escaping(Result<[Contractor], AFError>) -> Void) {
        guard var url = URL(string: Link.base.rawValue) else { return }
        url.append(path: resource.rawValue)
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let contractors = Contractor.getContractors(from: value)
                    completion(.success(contractors))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: POST methods
    func postRequest<T: Codable>(_ type: T,
                                 resource: RequestResource,
                                 _ completion: @escaping (Result<T, AFError>) -> Void) {
        guard var url = URL(string: Link.base.rawValue) else {
            completion(.failure(AFError.invalidURL(url: Link.base.rawValue)))
            return
        }
        url.append(path: resource.rawValue)
        
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
    
    // MARK: DELETE methods
    func deleteRequest(_ type: Int, resource: RequestResource) {
        guard var url = URL(string: Link.base.rawValue) else {
            return
        }
        url.append(path: resource.rawValue)
        url.append(path: String(type))
        
        AF.request(url, method: .delete, parameters: type).validate()
    }
}

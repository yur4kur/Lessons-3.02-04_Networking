//
//  NetworkManager.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 10.08.2023.
//

import Foundation

// MARK: - Network options
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

// MARK: - Network manager
class NetworkManager {
    
    // MARK: Singleton property
    static let shared = NetworkManager()
    
    // MARK: - URL
    //private let baseURL =
    
    // MARK: Get Users
    func fetchUsers(_ completionHandler: @escaping ([User]) -> Void) {
        guard var url = URL(string: URLs.base.rawValue) else { return }
        url.append(path: APIs.users.rawValue)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([User].self, from: data)
                completionHandler(users)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: Get Posts
    private func fetchPosts() {
        guard let url = URL(string: URLs.base.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([Post].self, from: data)
                print(users)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }

    // MARK: Get Comments
    private func fetchComments() {
        guard let url = URL(string: URLs.base.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([Comment].self, from: data)
                print(users)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private init() {}
}

//
//  NetworkHelpers.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 04.09.2023.
//

import Foundation

enum URLs: String {
    case base = "https://jsonplaceholder.typicode.com/"
}

enum API: String {
    case users
    case posts
    case comments
}

enum QueryItem: String {
    case userId
    case postId
}

enum HTTPHeader: String {
    case length = "Content-Length"
    case type = "Content-Type"
}

enum HTTPMethod: String {
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case invalidQueryURL
    case noData
    case noResponse
    case decodingError
    case noDescription
}

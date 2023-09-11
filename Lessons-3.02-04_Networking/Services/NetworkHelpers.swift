//
//  NetworkHelpers.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 04.09.2023.
//

enum Link: String {
    case base = "https://jsonplaceholder.typicode.com/"
}

enum API: String {
    case users
    case posts
    case comments
    case todos
}

enum QueryItem: String {
    case userId
    case postId
}

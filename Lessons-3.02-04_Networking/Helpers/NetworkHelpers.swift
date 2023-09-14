//
//  NetworkHelpers.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 04.09.2023.
//
// MARK: - Base URL
enum Link: String {
    case base = "https://jsonplaceholder.typicode.com/"
}

// MARK: - Request resources
enum RequestResource: String {
    case users
    case posts
    case comments
    case todos
}

// MARK: - Query items
enum QueryItem: String {
    case userId
    case postId
}

// MARK: - Comment mock headers
enum CommentHeaders: String {
    case name = "Jane"
    case email = "test@swiftbook.org"
}

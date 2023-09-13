//
//  Comment.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

struct Review: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
    init(postId: Int, id: Int, name: String, email: String, body: String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
    init(reviewJP: ReviewJP) {
        postId = Int(reviewJP.postId) ?? 0
        id = reviewJP.id
        name = reviewJP.name
        email = reviewJP.email
        body = reviewJP.body
    }
}

struct ReviewJP: Codable {
    let postId: String
    let id: Int
    let name: String
    let email: String
    let body: String

    init(review: Review) {
        postId = String(review.postId)
        id = review.id
        name = review.name
        email = review.email
        body = review.body
    }
}

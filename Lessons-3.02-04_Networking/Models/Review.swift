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
    
//    init(reviewData: [String: Any]) {
//        postId = reviewData["postId"] as? Int ?? 0
//        id = reviewData["id"] as? Int ?? 0
//        name = reviewData["name"] as? String ?? ""
//        email = reviewData["email"] as? String ?? ""
//        body = reviewData["body"] as? String ?? ""
//    }
//    
//    static func getReviews(from data: Any) -> [Review] {
//        guard let reviewData = data as? [[String: Any]] else {
//            return []
//        }
//        return reviewData.map { Review(reviewData: $0) }
//    }
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

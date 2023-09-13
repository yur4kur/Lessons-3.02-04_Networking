//
//  Post.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

struct Contract: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
//    init(userId: Int, id: Int, title: String, body: String) {
//        self.userId = userId
//        self.id = id
//        self.title = title
//        self.body = body
//    }
//    
//    init(contractData: [String: Any]) {
//        userId = contractData["userId"] as? Int ?? 0
//        id = contractData["id"] as? Int ?? 0
//        title = contractData["title"] as? String ?? ""
//        body = contractData["body"] as? String ?? ""
//    }
//    
//    static func getContracts(from data: Any) -> [Contract] {
//        guard let contractData = data as? [[String: Any]] else {
//            return []
//        }
//        return contractData.map { Contract(contractData: $0) }
//    }
}



//
//  Work.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 06.09.2023.
//

struct Work: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    init(userId: Int, id: Int, title: String, completed: Bool) {
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    init(workData: [String: Any]) {
        userId = workData["userId"] as? Int ?? 0
        id = workData["userId"] as? Int ?? 0
        title = workData["title"] as? String ?? ""
        completed = workData["userId"] as? Bool ?? false
    }
    
    static func getWorks(from data: Any) -> [Work] {
        guard let workData = data as? [[String: Any]] else {
            return []
        }
        return workData.map { Work(workData: $0) }
    }
}

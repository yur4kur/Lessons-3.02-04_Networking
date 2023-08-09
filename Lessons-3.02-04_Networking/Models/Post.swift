//
//  Post.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

struct Post: Decodable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

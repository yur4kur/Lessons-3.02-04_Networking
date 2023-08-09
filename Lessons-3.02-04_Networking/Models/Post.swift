//
//  Post.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

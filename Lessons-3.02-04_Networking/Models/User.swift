//
//  User.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
    let address: Address
    let company: Company
    let phone: String
    let website: String
    
    struct Address: Decodable {
        let street: String
        let city: String
        let zipcode: String
    }
    
    struct Company: Decodable {
        let name: String
        let catchPhrase: String
        let bs: String
    }
}

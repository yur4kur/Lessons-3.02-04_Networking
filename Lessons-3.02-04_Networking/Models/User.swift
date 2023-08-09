//
//  User.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

struct User: Decodable {
    var id: Int
    var name: String
    var email: String
    var address: Address
    var company: Company
    var phone: String
    
    struct Address: Decodable {
        var street: String
        var city: String
        var zipcode: String
    }
    
    struct Company: Decodable {
        var name: String
        var catchPhrase: String
        var bs: String
    }
}

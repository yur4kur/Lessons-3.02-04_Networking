//
//  User.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

struct Contractor: Decodable {
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
        
        init(street: String, city: String, zipcode: String) {
            self.street = street
            self.city = city
            self.zipcode = zipcode
        }
        
        init(address: [String: Any]) {
            street = address["street"] as? String ?? ""
            city = address["city"] as? String ?? ""
            zipcode = address["zipcode"] as? String ?? ""
        }
    }
    
    struct Company: Decodable {
        let name: String
        let catchPhrase: String
        let bs: String
        
        init(name: String, catchPhrase: String, bs: String) {
            self.name = name
            self.catchPhrase = catchPhrase
            self.bs = bs
        }
        
        init(company: [String: Any]) {
            name = company["name"] as? String ?? ""
            catchPhrase = company["catchPhrase"] as? String ?? ""
            bs = company["bs"] as? String ?? ""
        }
    }
    
    init(id: Int, name: String, email: String, address: Address, company: Company, phone: String, website: String) {
        self.id = id
        self.name = name
        self.email = email
        self.address = address
        self.company = company
        self.phone = phone
        self.website = website
    }
    
    init(contractorData: [String: Any]) {
        id = contractorData["id"] as? Int ?? 0
        name = contractorData["name"] as? String ?? ""
        email = contractorData["email"] as? String ?? ""
        address = Address(
            address: contractorData["address"] as? [String : Any] ?? [:]
        )
        company = Company(
            company: contractorData["company"] as? [String : Any] ?? [:]
        )
        phone = contractorData["phone"] as? String ?? ""
        website = contractorData["website"] as? String ?? ""
    }
    
    static func getContractors(from data: Any) -> [Contractor] {
        guard let contractorData = data as? [[String: Any]] else {
            return []
        }
        return contractorData.map { Contractor(contractorData: $0) }
    }
}

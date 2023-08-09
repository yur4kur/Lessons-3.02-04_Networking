//
//  ViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Types

    enum APIs: String {
        case users
        case posts
        case comments
    }

    // MARK: - Private properties

    private let baseURL = "https://jsonplaceholder.typicode.com/"

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
    }

    // MARK: - Private methods

    private func fetchUsers() {
        guard let url = URL(string: baseURL + APIs.users.rawValue) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([User].self, from: data)
                print(users)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }

    private func fetchPosts() {

    }

    private func fetchComments() {

    }
}


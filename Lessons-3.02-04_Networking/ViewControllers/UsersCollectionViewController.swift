//
//  UsersCollectionViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

import UIKit

// MARK: - APIs
enum APIs: String {
    case users
    case posts
    case comments
}

// MARK: - URL
private let baseURL = "https://jsonplaceholder.typicode.com/"

// MARK: - ViewController
final class UsersCollectionViewController: UICollectionViewController {
    
    // MARK: IBOutlets
    @IBOutlet var userCollectionView: UICollectionView!
    
    // MARK: Private properties
    private var users: [User] = [] {
        didSet {
            userCollectionView.reloadData()
        }
    }
    
    private var indexPath: IndexPath!
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers { [unowned self] users in
            DispatchQueue.main.async {
                self.users = users
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        users.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath
                                ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user",
                                                      for: indexPath)
        guard let cell = cell as? UserCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.userNameLabel.text = users[indexPath.item].name
        cell.companyNameLabel.text = "Company: \"\(users[indexPath.item].company.name)\""
        cell.companyBsLabel.text = users[indexPath.item].company.bs
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        if let vc = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: "UserInfoVC") as? UserInfoTableViewController {
            vc.user = users[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UsersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 150)
    }
}

// MARK: - Networking
extension UsersCollectionViewController {
    
    // MARK: Get Users
    private func fetchUsers(_ completionHandler: @escaping ([User]) -> Void) {
        guard let url = URL(string: baseURL + APIs.users.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([User].self, from: data)
                completionHandler(users)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: Get Posts
    private func fetchPosts() {
        guard let url = URL(string: baseURL + APIs.posts.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([Post].self, from: data)
                print(users)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }

    // MARK: Get Comments
    private func fetchComments() {
        guard let url = URL(string: baseURL + APIs.comments.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([Comment].self, from: data)
                print(users)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

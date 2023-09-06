//
//  ContractsTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 04.09.2023.
//

import UIKit

class ContractsTableViewController: UITableViewController {
    
    // MARK: - Public propertty
    
    var user: User!
    
    // MARK: - Private property
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var newPostTitle = "Veni vidi vici"
    private var newPostBody = "In vino veritas"
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts(by: user.id)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let headerTitleLabel = UILabel(
            frame: CGRect(x: 16,
                          y: 3,
                          width: tableView.frame.width,
                          height: 20)
        )
        headerTitleLabel.text = "Project: \"\(user.company.catchPhrase)\""
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerTitleLabel.textColor = .white
        
        let contentView = UIView()
        contentView.addSubview(headerTitleLabel)
        
        return contentView
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        view.backgroundColor = .gray
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
                identifier: "contractTabBarVC") as? UITabBarController {
            
            guard let textVC = tabBarVC.viewControllers?.first as? ContractTextTableViewController else { return }
            textVC.post = posts[indexPath.row]
            guard let worksVC = tabBarVC.viewControllers?.last as? ContractWorksTableViewController else { return }
            navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contractInfo",
                                                 for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = "\(indexPath.row + 1): \((posts[indexPath.row].title).capitalized)"
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedPost = posts[indexPath.row]
            deletePost(deletedPost)
            self.posts.remove(at: indexPath.row)

        }
    }
    // MARK: - IBAction
    
    @IBAction func addContractTapped(_ sender: UIBarButtonItem) {
        let newPost = Post(userId: user.id,
                           id: 0,
                           title: newPostTitle,
                           body: newPostBody)
        addPost(newPost)
    }
}
    
    // MARK: - Networking
    
    extension ContractsTableViewController {
        private func fetchPosts(by userID: Int) {
            NetworkManager.shared.fetchQuery(by: userID,
                                             [Post].self,
                                             .userId,
                                             API: .posts) { result in
                switch result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        private func addPost(_ newPost: Post) {
            NetworkManager.shared.postRequest(newPost, API: .posts) { result in
                switch result {
                case .success(let serverPost):
                    DispatchQueue.main.async { [weak self] in
                        self?.posts.append(serverPost)
                        print("Server returned: \(serverPost)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        private func deletePost(_ deletedPost: Post) {
            NetworkManager.shared.deleteRequest(deletedPost,
                                                API: .posts) { result in
                switch result {
                case .success(let serverPost):
                    print("Delete: \(serverPost)")
                case .failure(let error):
                    print("No return: \(error.localizedDescription)")
                }
            }
        }
    }


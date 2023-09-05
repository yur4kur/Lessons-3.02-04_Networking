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
        tableView.deselectRow(at: indexPath, animated: true)
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
        cellContent.text = "Preamble: \(posts[indexPath.row].title)"
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.posts.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

// MARK: - Networking

extension ContractsTableViewController {
    private func fetchPosts(by userID: Int) {
        NetworkManager.shared.fetchQuery(by: userID,
                                         [Post].self,
                                         QueryItem.userId.rawValue,
                                         API.posts.rawValue) { result in
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
}

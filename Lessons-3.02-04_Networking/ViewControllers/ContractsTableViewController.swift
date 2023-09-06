//
//  ContractsTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 04.09.2023.
//

import UIKit

class ContractsTableViewController: UITableViewController {
    
    // MARK: - Public propertty
    
    var contractor: Contractor!
    
    // MARK: - Private property
    
    var contracts: [Contract] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var newPostTitle = "Veni vidi vici"
    private var newPostBody = "In vino veritas"
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts(by: contractor.id)
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
        headerTitleLabel.text = "Project: \"\(contractor.company.catchPhrase)\""
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
            textVC.contract = contracts[indexPath.row]
            
            guard let worksVC = tabBarVC.viewControllers?.last as? ContractWorksTableViewController else { return }
            worksVC.contractor = contractor
            
            navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        contracts.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contractInfo",
                                                 for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = "\(indexPath.row + 1): \((contracts[indexPath.row].title).capitalized)"
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedPost = contracts[indexPath.row]
            deletePost(deletedPost)
            self.contracts.remove(at: indexPath.row)

        }
    }
    // MARK: - IBAction
    
    @IBAction func addContractTapped(_ sender: UIBarButtonItem) {
        let newPost = Contract(userId: contractor.id,
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
                                             [Contract].self,
                                             .userId,
                                             API: .posts) { result in
                switch result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.contracts = posts
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        private func addPost(_ newPost: Contract) {
            NetworkManager.shared.postRequest(newPost, API: .posts) { result in
                switch result {
                case .success(let serverPost):
                    DispatchQueue.main.async { [weak self] in
                        self?.contracts.append(serverPost)
                        print("Server returned: \(serverPost)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        private func deletePost(_ deletedPost: Contract) {
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


//
//  UserInfoTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

import UIKit

final class UserInfoTableViewController: UITableViewController {
    
    // MARK: - Public property
    var user: User!
    
    // MARK: - Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = user.name
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let projectNameLabel = UILabel(
        frame: CGRect(
            x: 16,
            y: 3,
            width: tableView.frame.width,
            height: 20))
        projectNameLabel.text = "Project: \"\(user.company.catchPhrase)\""
        projectNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        projectNameLabel.textColor = .white
        
        let contentView = UIView()
        contentView.addSubview(projectNameLabel)
        
        return contentView
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        view.backgroundColor = .gray
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfo", for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        
        switch indexPath.row {
        case 0:
            cellContent.text = user.phone
            cellContent.image = UIImage(systemName: "phone")
        case 1:
            cellContent.text = user.email
            cellContent.image = UIImage(systemName: "tray")
        default:
            cellContent.text = user.website
            cellContent.image = UIImage(systemName: "globe")
        }
        
        cell.contentConfiguration = cellContent
        
        return cell
    }
}

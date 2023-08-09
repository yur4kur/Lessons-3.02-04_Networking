//
//  UserInfoTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

import UIKit

class UserInfoTableViewController: UITableViewController {
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = user.name
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let motoNameLabel = UILabel(
        frame: CGRect(
            x: 16,
            y: 3,
            width: tableView.frame.width,
            height: 20))
        motoNameLabel.text = user.company.catchPhrase
        motoNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        motoNameLabel.textColor = .white
        
        let contentView = UIView()
        contentView.addSubview(motoNameLabel)
        
        return contentView
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        view.backgroundColor = .gray
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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

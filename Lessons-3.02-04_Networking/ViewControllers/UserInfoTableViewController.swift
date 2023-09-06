//
//  UserInfoTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

import UIKit

final class UserInfoTableViewController: UITableViewController {
    
    
    
    // MARK: - Public property
    
    var contractor: Contractor!
    
    // MARK: - Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = contractor.name
        addFooter()
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        
        let headerTitleLabel = addHeaderTitleLabel(width: tableView.frame.width)
        
        switch section {
        case 0:
            headerTitleLabel.text = "Contact details"
        default:
            headerTitleLabel.text = "Postal address"
        }
        
        let contentView = UIView()
        contentView.addSubview(headerTitleLabel)
        
        return contentView
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        view.backgroundColor = .gray
    }

    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfo",
                                                 for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cellContent.text = contractor.phone
                cellContent.image = UIImage(systemName: "phone")
            case 1:
                cellContent.text = contractor.email
                cellContent.image = UIImage(systemName: "envelope")
            default:
                cellContent.text = String("https://\(contractor.website)")
                cellContent.image = UIImage(systemName: "globe")
            }
        default:
            switch indexPath.row {
            case 0:
                cellContent.text = "\(contractor.address.city) City"
            case 1:
                cellContent.text = "\(contractor.address.street) St."
            default:
                cellContent.text = "ZipCode: \(contractor.address.zipcode)"
            }
        }
        
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func addFooter() {
        let tableViewFooter =  UserInfoTableViewFooter(
            frame: CGRect(x: 0,
                          y: 0,
                          width: self.view.frame.width,
                          height: 200))
        tableViewFooter.showContractsButton.addTarget(self,
                                                      action: #selector(showContractsTapped),
                                                      for: .touchUpInside)
        self.tableView.tableFooterView = tableViewFooter
    }
    
    @objc private func showContractsTapped () {
        if let contractsNavVC = UIStoryboard(name: "Main",
                                 bundle: nil).instantiateViewController(
                                    withIdentifier: "contractsNavVC"
                                 ) as? UINavigationController {
            
            guard let contractsVC = contractsNavVC.topViewController as? ContractsTableViewController else { return }
            contractsVC.contractor = contractor
            
            navigationController?.pushViewController(contractsVC, animated: true)
        }
    }
    
}

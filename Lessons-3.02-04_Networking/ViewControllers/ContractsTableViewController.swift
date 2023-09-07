//
//  ContractsTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 04.09.2023.
//

import UIKit

final class ContractsTableViewController: UITableViewController {
    
    // MARK: - Public propertty
    
    var contractor: Contractor!
    
    // MARK: - Private property
    
    var contracts: [Contract] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var newContractTitle = "Veni vidi vici"
    private var newContractBody = "In vino veritas"
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContracts(by: contractor.id)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
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
    
    override func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        
        view.backgroundColor = .gray
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        if let contractsNavVC = UIStoryboard(
            name: Constants.mainStoryboard,
            bundle: nil
        )
            .instantiateViewController(
                withIdentifier: Constants.contractsNavVC
            )
            as? UINavigationController {
            
            guard let contractTextVC = contractsNavVC
                .topViewController as? ContractTextTableViewController else { return }
            contractTextVC.contract = contracts[indexPath.row]
            
            navigationController?.pushViewController(
                contractTextVC,
                animated: true
            )
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        contracts.count
    }
    
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.contractInfoTableViewCell,
            for: indexPath
        )
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = "\(indexPath.row + 1): \((contracts[indexPath.row].title).capitalized)"
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        
        if editingStyle == .delete {
            let deletedContract = contracts[indexPath.row]
            deleteContract(deletedContract)
            self.contracts.remove(at: indexPath.row)
            
        }
    }
    // MARK: - IBAction
    
    @IBAction func addContractTapped(
        _ sender: UIBarButtonItem) {
            
            let newContract = Contract(
                userId: contractor.id,
                id: 0,
                title: newContractTitle,
                body: newContractBody
            )
            addContract(newContract)
        }
}

// MARK: - Networking methods

extension ContractsTableViewController {
    
    private func fetchContracts(by userID: Int) {
        
        NetworkManager.shared.fetchQuery(
            by: userID,
            [Contract].self,
            queryBy: .userId,
            API: .posts
        ) { result in
            
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
    
    private func addContract(_ newContract: Contract) {
        
        NetworkManager.shared.postRequest(
            newContract,
            API: .posts
        ) { result in
            
            switch result {
            case .success(let serverContract):
                DispatchQueue.main.async { [weak self] in
                    self?.contracts.append(serverContract)
                    print("Server returned: \(serverContract)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteContract(_ deletedContract: Contract) {
        
        NetworkManager.shared.deleteRequest(
            deletedContract,
            API: .posts
        ) { result in
            
            switch result {
            case .success(let serverContract):
                print("Delete: \(serverContract)")
            case .failure(let error):
                print("No return: \(error.localizedDescription)")
            }
        }
    }
}


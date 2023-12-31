//
//  ContractWorksTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 06.09.2023.
//

import UIKit

final class ContractWorksTableViewController: UITableViewController {
    
    // MARK: Public properties
    var contractor: Contractor!
    
    // MARK: Private properties
    private var works: [Work] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWorks(by: contractor.id)
    }
}

// MARK: - Table view delegate
extension ContractWorksTableViewController {
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = addHeaderTitleLabel(width: tableView.frame.width)
        titleLabel.text = "Agreed Works Status"
        
        let contentView = UIView()
        contentView.addSubview(titleLabel)
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
}

// MARK: Table view data source
extension ContractWorksTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        works.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.contractWorksTableViewCell,
                                 for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = works[indexPath.row].title.capitalized
        cellContent.image = {
            var image = UIImage()
            if works[indexPath.row].completed {
                image = UIImage.checkmark
            } else {
                image = UIImage.remove
            }
            return image
        }()
        
        cell.contentConfiguration = cellContent
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedWork = works[indexPath.row]
            delete(work: deletedWork)
            works.remove(at: indexPath.row)
        }
    }
}

// MARK: - Networking methods
extension ContractWorksTableViewController {
    
    private func fetchWorks(by userID: Int) {
        NetworkManager.shared.fetchQuery(by: userID,
                                         [Work].self,
                                         queryBy: .userId,
                                         resource: .todos) { result in
            switch result {
            case .success(let works):
                DispatchQueue.main.async {
                    self.works = works
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func delete(work: Work) {
        NetworkManager.shared.deleteRequest(work.id, resource: .todos)
    }
}

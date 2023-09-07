//
//  ContractTextTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 06.09.2023.
//

import UIKit

final class ContractTextTableViewController: UITableViewController {
    
    // MARK: - Public property
    
    var contract: Contract!
    
    // MARK: - Private property
    
    private var review: [Review] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Override properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchComments(by: contract.id)
    }
    
    // MARK: Table view delegate
    
    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
        let titleLabel = addHeaderTitleLabel(
            width: tableView.frame.width
        )
        
        switch section {
        case 0:
            titleLabel.text = "Brief Description"
        default:
            titleLabel.text = "Revisions"
        }
        
        let contentView = UIView()
        contentView.addSubview(titleLabel)
        
        return contentView
    }
    
    override func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        
        view.backgroundColor = .gray
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return review.count
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.contractTextTableViewCell,
            for: indexPath
        )
        
        var cellContent = cell.defaultContentConfiguration()
        switch indexPath.section {
        case 0:
            cellContent.text = contract.body.capitalized
        default:
            cellContent.text = "\([indexPath.row + 1]):\(review[indexPath.row].body.capitalized)"
        }
        
        cell.contentConfiguration = cellContent
        
        return cell
    }
}
// MARK: - Networking methods
extension ContractTextTableViewController {
    
    private func fetchComments(by postID: Int) {
        
        NetworkManager.shared.fetchQuery(
            by: postID,
            [Review].self,
            queryBy: .postId,
            API: .comments
        ) { result in
            
            switch result {
            case .success(let comments):
                DispatchQueue.main.async {
                    self.review = comments
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//
//  ContractTextTableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 06.09.2023.
//

import UIKit

// MARK: - Protocol for adding reviews
protocol INewReviewViewControllerDelegate {
    func addReview(_ newReview: ReviewJP)
}

// MARK: - ContractTextTableViewController
final class ContractTextTableViewController: UITableViewController {
    
    // MARK: Public properties
    var contract: Contract!
    
    // MARK: Private properties
    private var reviews: [Review] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchReviews(by: contract.id)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newReivewNavVC = segue
            .destination as? UINavigationController else { return }
        
        guard let newReviewVC = newReivewNavVC
            .topViewController as? NewReviewViewController else { return }
        newReviewVC.delegate = self
        newReviewVC.contract = contract
    }
}

// MARK: - Table view delegate
extension ContractTextTableViewController {
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = addHeaderTitleLabel(width: tableView.frame.width)
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

// MARK: - Table view data source
extension ContractTextTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return reviews.count
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.contractTextTableViewCell,
                                 for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        switch indexPath.section {
        case 0:
            cellContent.text = contract.body.capitalized
        default:
            cellContent.text = "\([indexPath.row + 1]):\(reviews[indexPath.row].body.capitalized)"
        }
        
        cell.contentConfiguration = cellContent
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedReview = reviews[indexPath.row]
            delete(review: deletedReview)
            reviews.remove(at: indexPath.row)
        }
    }
}

// MARK: - Networking methods
extension ContractTextTableViewController {
    private func fetchReviews(by postID: Int) {
        NetworkManager.shared.fetchQuery(by: postID,
                                         [Review].self,
                                         queryBy: .postId,
                                         resource: .comments) { result in
            switch result {
            case .success(let reviews):
                DispatchQueue.main.async {
                    self.reviews = reviews
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func delete(review: Review) {
        NetworkManager.shared.deleteRequest(review.id, resource: .comments)
    }
}

// MARK: - INewReviewViewControllerDelegate
extension ContractTextTableViewController: INewReviewViewControllerDelegate {
    internal func addReview(_ newReview: ReviewJP) {
        NetworkManager.shared.postRequest(newReview,
                                          resource: .comments) { result in
            switch result {
            case .success(let serverReview):
                let newReview = Review(reviewJP: serverReview)
                DispatchQueue.main.async { [weak self] in
                    self?.reviews.append(newReview)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

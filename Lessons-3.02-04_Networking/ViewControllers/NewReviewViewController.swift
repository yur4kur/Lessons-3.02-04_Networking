//
//  NewReviewViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 11.09.2023.
//

import UIKit

final class NewReviewViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var newReviewTextView: UITextView!
    
    // MARK: Public properties
    var delegate: INewReviewViewControllerDelegate?
    var contract: Contract!
    
    // MARK: IBActions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let newReview = Review(postId: contract.id,
                               id: 0,
                               name: CommentHeaders.name.rawValue,
                               email: CommentHeaders.email.rawValue,
                               body: newReviewTextView.text)
        let newReviewJP = ReviewJP(review: newReview)
        delegate?.addReview(newReviewJP)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

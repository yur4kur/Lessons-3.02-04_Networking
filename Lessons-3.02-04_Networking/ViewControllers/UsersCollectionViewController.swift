//
//  UsersCollectionViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

import UIKit

final class UsersCollectionViewController: UICollectionViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var userCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    
    private var users: [User] = [] {
        didSet {
            userCollectionView.reloadData()
        }
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        fetchUsers()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        users.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath
                                ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user",
                                                      for: indexPath)
        guard let cell = cell as? UserCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.userNameLabel.text = users[indexPath.item].name
        cell.companyNameLabel.text = "Company: \"\(users[indexPath.item].company.name)\""
        cell.companyBsLabel.text = users[indexPath.item].company.bs
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        if let vc = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: "UserInfoVC") as? UserInfoTableViewController {
            vc.user = users[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UsersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 150)
    }
}

// MARK: - Networking

extension UsersCollectionViewController {
    private func fetchUsers() {
        NetworkManager.shared.fetch([User].self,
                                    API: .users) { result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

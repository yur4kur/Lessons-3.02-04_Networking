//
//  UsersCollectionViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 09.08.2023.
//

import UIKit

final class ContractorsCollectionViewController: UICollectionViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var contractorCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    
    private var contractors: [Contractor] = [] {
        didSet {
            contractorCollectionView.reloadData()
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
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        contractors.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.contractorCollectionViewCell,
            for: indexPath
        )
        
        guard let cell = cell as? UserCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.userNameLabel.text = contractors[indexPath.item].name
        cell.companyNameLabel.text = "Company: \"\(contractors[indexPath.item].company.name)\""
        cell.companyBsLabel.text = contractors[indexPath.item].company.bs
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let vc = UIStoryboard(
            name: Constants.mainStoryboard,
            bundle: nil
        )
            .instantiateViewController(
                withIdentifier: Constants.contractorInfoVC
            ) as? ContractorInfoTableViewController {
            
            vc.contractor = contractors[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ContractorsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 150)
    }
}

// MARK: - Networking method

extension ContractorsCollectionViewController {
    
    private func fetchUsers() {
        NetworkManager.shared.fetchContractors(
            API: .users
        ) { result in
            switch result {
            case .success(let contractors):
                DispatchQueue.main.async { [unowned self] in
                    self.contractors = contractors
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//
//  UserInforTableViewFooter.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 04.09.2023.
//

import UIKit

class ContractorInfoTableViewFooter: UIView {

    // MARK: - Public property
    
    let showContractsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Contracts", for: .normal)
        button.backgroundColor = .systemGray2
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(showContractsButton)
        showContractsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showContractsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            showContractsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            showContractsButton.widthAnchor.constraint(equalToConstant: 200),
            showContractsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  Extension + TableViewController.swift
//  Lessons-3.02-04_Networking
//
//  Created by Юрий Куринной on 06.09.2023.
//

import UIKit

func addHeaderTitleLabel(width: CGFloat) -> UILabel {
    let headerTitleLabel = UILabel(
        frame: CGRect(x: 16,
                      y: 3,
                      width: width,
                      height: 20))
    headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    headerTitleLabel.textColor = .white
    return headerTitleLabel
}

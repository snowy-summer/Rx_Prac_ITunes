//
//  AppDetailViewController.swift
//  iTunes
//
//  Created by 최승범 on 8/8/24.
//

import UIKit
import SnapKit

final class AppDetailViewController: UIViewController {
    
    private let appIconImageView = UIImageView()
    private let downloadButton = UIButton()
    private let appNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    private func configure() {
        
        view.backgroundColor = .white
        view.addSubview(appIconImageView)
        view.addSubview(appNameLabel)
        view.addSubview(downloadButton)
        
        appIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        downloadButton.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }
    }
}

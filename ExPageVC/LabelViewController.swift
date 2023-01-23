//
//  LabelViewController.swift
//  ExPageVC
//
//  Created by 김종권 on 2023/01/23.
//

import UIKit

final class LabelViewController: UIViewController {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleText: String? {
        didSet { label.text = titleText }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

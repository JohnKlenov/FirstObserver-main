//
//  DetailViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 29.04.23.
//


import UIKit

class DetailViewController: UIViewController {
    
    let nameMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = R.Colors.label
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        view.addSubview(nameMallLabel)
        nameMallLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nameMallLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

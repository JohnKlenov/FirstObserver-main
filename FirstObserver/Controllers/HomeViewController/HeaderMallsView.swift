//
//  HeaderMallsView.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit

class HeaderMallsView: UICollectionReusableView {
        
    static let headerIdentifier = "HeaderMalls"
    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor = .clear
        label.tintColor = R.Colors.label
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        setupConstraints()
        backgroundColor = .clear
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)])
    }
    
    func configureCell(title: String) {
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

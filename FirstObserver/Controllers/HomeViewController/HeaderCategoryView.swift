//
//  HeaderCategoryView.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit

protocol HeaderCategoryViewDelegate: AnyObject {
    func didSelectAllBrandButton()
}


class HeaderCategoryView: UICollectionReusableView {
        
    static let headerIdentifier = "HeaderCategory"
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
    
    let allBrand: UIButton = {
        var configButton = UIButton.Configuration.gray()
        configButton.title = R.Strings.TabBarController.Home.ViewsHome.headerCategoryViewAllShops
        configButton.baseForegroundColor = R.Colors.systemPurple
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(allBrandHandler), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: HeaderCategoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(allBrand)
        setupConstraints()
        backgroundColor = .clear
    }
//    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
    private func setupConstraints() {
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5), allBrand.topAnchor.constraint(equalTo: topAnchor, constant: 5), allBrand.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), allBrand.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)])
    }
    
    func configureCell(title: String) {
        label.text = title
    }
    
    @objc func allBrandHandler() {
        delegate?.didSelectAllBrandButton()
        print("allBrandHandler allBrandHandler allBrandHandler")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

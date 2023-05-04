//
//  CatalogCollectionReusableView.swift
//  FirstObserver
//
//  Created by Evgenyi on 2.05.23.
//

import UIKit

class HeaderCatalogCollectionReusableView: UICollectionReusableView {
    
    static let headerIdentifier = "HeaderCatalogVC"
    
    let segmentedControl: UISegmentedControl = {
        let item = [R.Strings.TabBarController.Home.ViewsHome.segmentedControlWoman,R.Strings.TabBarController.Home.ViewsHome.segmentedControlMan]
        let segmentControl = UISegmentedControl(items: item)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
//        segmentControl.addTarget(nil, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        segmentControl.backgroundColor = R.Colors.systemFill
        return segmentControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(segmentedControl)
        setupConstraints()
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60), segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60), segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
        
}

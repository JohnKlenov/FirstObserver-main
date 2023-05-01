//
//  HeaderMallsView.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit

class HeaderMallsView: UICollectionReusableView {
        
    static let headerIdentifier = "HeaderMalls"
    
    let segmentedControl: UISegmentedControl = {
        let item = [R.Strings.TabBarController.Home.ViewsHome.segmentedControlWoman,R.Strings.TabBarController.Home.ViewsHome.segmentedControlMan]
        let segmentControl = UISegmentedControl(items: item)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
//        segmentControl.addTarget(nil, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        segmentControl.backgroundColor = R.Colors.systemFill
        return segmentControl
    }()
    
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
        addSubview(segmentedControl)
        addSubview(label)
        setupConstraints()
        backgroundColor = .clear
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 5), segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40), segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40), label.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)])
    }
    
    func configureCell(title: String) {
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

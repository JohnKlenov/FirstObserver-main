//
//  FooterViewCollectionView.swift
//  FirstObserver
//
//  Created by Evgenyi on 25.02.23.
//

import UIKit

protocol FooterViewSectionDelegate: AnyObject {
    func currentPage(index: Int)
}
class FooterViewCollectionView: UICollectionReusableView {
    static let footerIdentifier = "FooterView"
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = .systemOrange
        control.pageIndicatorTintColor = R.Colors.backgroundLithGray
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.Colors.backgroundActive
        setupView()
    }
    
    func configure(with numberOfPages: Int) {
            pageControl.numberOfPages = numberOfPages
        }
    
    private func setupView() {
//            backgroundColor = .clear
            
            addSubview(pageControl)
            
            NSLayoutConstraint.activate([
                pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
//        fatalError("init(coder:) has not been implemented")
    }
}

extension FooterViewCollectionView: FooterViewSectionDelegate {
    func currentPage(index: Int) {
        pageControl.currentPage = index
    }
    
    
}

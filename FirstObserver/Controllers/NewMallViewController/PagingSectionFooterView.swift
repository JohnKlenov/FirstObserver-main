//
//  PagingSectionFooterView.swift
//  FirstObserver
//
//  Created by Evgenyi on 22.02.23.
//

import UIKit

protocol PagingSectionDelegate: AnyObject {
    func currentPage(index: Int)
}
class PagingSectionFooterView: UICollectionReusableView {
    static let footerIdentifier = "FooterMall"
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = .systemOrange
        control.pageIndicatorTintColor = .systemGray5
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func configure(with numberOfPages: Int) {
            pageControl.numberOfPages = numberOfPages
        }
    
    private func setupView() {
            backgroundColor = .clear
            
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

extension PagingSectionFooterView: PagingSectionDelegate {
    func currentPage(index: Int) {
        pageControl.currentPage = index
        print("PagingSectionDelegate")
    }
    
    
}

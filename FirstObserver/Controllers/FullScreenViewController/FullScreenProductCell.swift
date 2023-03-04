//
//  FullScreenProductCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.03.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI


final class FullScreenProductCell: UICollectionViewCell {
    
    static var reuseID: String = "FullScreenProductCell"
    var storage: Storage!
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
//        image.backgroundColor = .clear
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .black
        storage = Storage.storage()
        
        contentView.addSubview(scrollView)
//        addSubview(scrollView)
        scrollView.addSubview(imageView)
        setupScrollView()
    }
    
    private func setupScrollView() {
        
        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
    
    func configureCell(refImage:String) {
        let refStorage = storage.reference(forURL: refImage)
        imageView.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

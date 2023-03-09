//
//  FullScreenViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.03.23.
//

import Foundation
import UIKit


final class FullScreenViewController: UIViewController {

    private var imageProductCollectionView : UICollectionView!
    
    private let deleteImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "Delete50")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let imageTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 1
        return recognizer
    }()
    
    private let pagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .lightGray
        label.backgroundColor = .clear
        return label
    }()
    
    var productImages: [String] = []
    var indexPath = IndexPath(item: 0, section: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        pagesLabel.text = "\(indexPath.row + 1)/\(productImages.count)"

        setupCollectionView()
        imageTapGestureRecognizer.addTarget(self, action: #selector(didTapDeleteImage(_:)))
        deleteImage.addGestureRecognizer(imageTapGestureRecognizer)
        view.addSubview(deleteImage)
        view.addSubview(pagesLabel)
        
        setupConstraints()
        imageProductCollectionView.performBatchUpdates(nil) { (_) in
            self.imageProductCollectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == imageProductCollectionView {
            let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pagesLabel.text = "\(currentPage + 1)/\(productImages.count)"
        }
    }
    
    @objc func didTapDeleteImage(_ gestureRcognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        imageProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageProductCollectionView.delegate = self
        imageProductCollectionView.dataSource = self
        imageProductCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageProductCollectionView.register(FullScreenProductCell.self, forCellWithReuseIdentifier: FullScreenProductCell.reuseID)

        imageProductCollectionView.backgroundColor = .clear
        imageProductCollectionView.isPagingEnabled = true
        imageProductCollectionView.showsVerticalScrollIndicator = false
        imageProductCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(imageProductCollectionView)
    }
    
    private func setupConstraints() {
        imageProductCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageProductCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageProductCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageProductCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        deleteImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        deleteImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        deleteImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        deleteImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pagesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
    }
}


extension FullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenProductCell", for: indexPath) as! FullScreenProductCell
        cell.configureCell(refImage: productImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
}

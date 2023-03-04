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
    var productImages: [String] = []
    var indexPath = IndexPath(item: 0, section: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        setupConstraints()
//        imageProductCollectionView.contentInsetAdjustmentBehavior = .never
//        imageProductCollectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        imageProductCollectionView.performBatchUpdates(nil) { (_) in
            print("performBatchUpdates(nil)")
            print(" performBatchUpdates(nil) - \(self.indexPath.item) , indexPath.section - \(self.indexPath.section)")
            self.imageProductCollectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        imageProductCollectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
//        imageProductCollectionView.reloadData()
        }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        imageProductCollectionView.collectionViewLayout.invalidateLayout()
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
//        imageProductCollectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(imageProductCollectionView)
    }
    
    private func setupConstraints() {
        imageProductCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageProductCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageProductCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageProductCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
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

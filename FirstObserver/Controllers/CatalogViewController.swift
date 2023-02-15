//
//  CatalogViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit

class CatalogViewController: UIViewController {
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // MARK: FB property
    let managerFB = FBManager.shared
    
    var heightCellCV:CGFloat!
    var arrayCatalog: [PreviewCategory] = []
    var arrayPins: [PlacesTest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Catalog"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        heightCellCV = (collectionView.frame.height/3)*0.86
        getFetchDataHVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        managerFB.getPreviewCatalog { catalog in
            self.arrayCatalog = catalog
            self.collectionView.reloadData()
        }
    }
    
    private func getFetchDataHVC() {
        
        guard let tabBarVCs = tabBarController?.viewControllers else {return}
        
        for vc in tabBarVCs {
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.topViewController as? NewHomeViewController {
                    self.arrayPins = homeVC.placesMap

                }
            }
        }
    }
}


extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCatalog.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCollectionViewCell", for: indexPath) as! CatalogCollectionViewCell
        cell.setupCell(model: arrayCatalog[indexPath.item], currentFrame: CGSize(width: collectionView.frame.width - 20, height: heightCellCV))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 20, height: heightCellCV)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchCategory = arrayCatalog[indexPath.item].brand
        let allProductCategoryVC = UIStoryboard.vcById("AllProductViewController") as! AllProductViewController
        allProductCategoryVC.pathRefAllPRoductVC = searchCategory
//        let refCategory = Database.database().reference(withPath: "brands")
//        allProductCategoryVC.categoryRef = refCategory
        allProductCategoryVC.arrayPin = arrayPins
        self.navigationController?.pushViewController(allProductCategoryVC, animated: true)
    }
    
}



//        ref.child("catalog").observe(.value) { [weak self] (snapshot) in
//            var arrayCatalog = [PreviewCategory]()
//            for item in snapshot.children {
//                let category = item as! DataSnapshot
//                let model = PreviewCategory(snapshot: category)
//                arrayCatalog.append(model)
//            }
//            self?.arrayCatalog = arrayCatalog
//            self?.collectionView.reloadData()
//        }

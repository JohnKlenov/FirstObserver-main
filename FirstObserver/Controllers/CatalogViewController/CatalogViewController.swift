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
        
        title = R.Strings.TabBarController.Catalog.title
        view.backgroundColor = R.Colors.systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        heightCellCV = (collectionView.frame.height/3)*0.86
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Catalog viewWillAppear")
        managerFB.removeObserverForCartProductsUser()
        navigationController?.navigationBar.prefersLargeTitles = true
        getPlacesMapHVC()
        managerFB.getPreviewCatalog { [weak self] catalog in
            self?.arrayCatalog = catalog
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("Catalog viewWillDisappear")
        navigationController?.navigationBar.prefersLargeTitles = false
        managerFB.removeObserverCatalog()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Catalog viewDidDisappear")
    }
    
    private func getPlacesMapHVC() {
        
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

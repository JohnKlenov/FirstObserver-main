//
//  CatalogViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit

class CatalogViewController: ParentNetworkViewController {
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: FB property
    let managerFB = FBManager.shared
    let defaults = UserDefaults.standard
    private var currentGender = ""
    
    var heightCellCV:CGFloat!
    var arrayCatalog: [PreviewCategory] = [] {
        didSet {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            collectionView.reloadData()
        }
    }
    var arrayPins: [PlacesTest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.Strings.TabBarController.Catalog.title
        view.backgroundColor = R.Colors.systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        heightCellCV = (collectionView.frame.height/3)*0.86
        collectionView.register(HeaderCatalogCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCatalogCollectionReusableView.headerIdentifier)
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        currentGender = gender
        getDataFB(path: gender)
        configureActivityView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        managerFB.removeObserverForCartProductsUser()
        getPlacesHVC()
        switchGender()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("Catalog viewWillDisappear")
//        managerFB.removeObserverCatalog()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Catalog viewDidDisappear")
    }
    
    // MARK: - another methods
    
    private func getPlacesHVC() {
        guard let tabBarVCs = tabBarController?.viewControllers else {return}
        for vc in tabBarVCs {
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.topViewController as? NewHomeViewController {
                    self.arrayPins = homeVC.placesMap
                }
            }
        }
    }
    
    private func getDataFB(path: String) {
        managerFB.getPreviewCatalogGender(path: path) { catalog in
            self.arrayCatalog = catalog
        }
    }
    
    private func switchGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        if currentGender != gender {
            configureActivityView()
            managerFB.removeObserverCatalogGender(path: currentGender)
            currentGender = gender
            getDataFB(path: currentGender)
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
        allProductCategoryVC.title = searchCategory
//        let refCategory = Database.database().reference(withPath: "brands")
//        allProductCategoryVC.categoryRef = refCategory
        allProductCategoryVC.arrayPin = arrayPins
        self.navigationController?.pushViewController(allProductCategoryVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCatalogCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderCatalogCollectionReusableView
        headerView.delegate = self
        headerView.configureCell()
        return headerView
    }
    
}

extension CatalogViewController: HeaderCatalogCollectionViewDelegate {
    func didSelectSegmentControl() {
        switchGender()
    }
}










//    private lazy var activityView: ActivityContainerView = {
//        let view = ActivityContainerView()
//        view.layer.cornerRadius = 8
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    private func configureActivityView() {
//        view.addSubview(activityView)
//        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        activityView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
//        activityView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
//        activityView.startAnimating()
//    }

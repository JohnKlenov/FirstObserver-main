//
//  BrandsViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 27.08.22.
//

import UIKit

class BrandsViewController: ParentNetworkViewController {
    

    var heightCollectionView:CGFloat!
    var selectedGroup:PopularGroup?
    var indexGroupsCollectionView = 0
//    {
//        didSet {
//            if let selectedGroup = self.selectedGroup {
//                self.title = selectedGroup.name
//            }
//        }
//    }
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightGroupsCV: NSLayoutConstraint!
    
    
    // MARK: - FirebaseProperty -
    
    let managerFB = FBManager.shared
//    var pathRefBrandVC = "nul"
    var pathRefBrandVC: String?
    var computerPathBrandVC: String {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        let path = "Brands\(gender)"
        var fullPath = ""
        if let pathRefBrandVC = pathRefBrandVC {
            fullPath = "\(path)/\(pathRefBrandVC)"
        } else {
            fullPath = path
        }
        return fullPath
    }
    
    var pathRefAllPRoductVC: String?
    var productsForCategory: PopularGarderob? {
        didSet {
            if let garderob = productsForCategory, !garderob.groups.isEmpty {
                selectedGroup = garderob.groups[indexGroupsCollectionView]
            }
//            if let group = productsForCategory?.groups[indexGroupsCollectionView], let groups = productsForCategory?.groups, groups.count > 0 {
//                selectedGroup = group
//            } else {
////                self.title = R.Strings.OtherControllers.BrandProducts.title
//            }
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            groupsCollectionView.reloadData()
            collectionView.reloadData()
        }
    }
    var arrayPin: [Places] = []
    var cartProducts: [PopularProduct] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = R.Colors.systemBackground
        configureActivityView()
        
        let nibGroup = UINib(nibName: "GroupCell", bundle: nil)
        groupsCollectionView.register(nibGroup, forCellWithReuseIdentifier: "GroupCell")
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.backgroundColor = .clear
        
//        let nibProduct = UINib(nibName: "ProductCell", bundle: nil)
//        collectionView.register(nibProduct, forCellWithReuseIdentifier: "ProductCell")
        collectionView.register(ProductCellForBrandsVC.self, forCellWithReuseIdentifier: ProductCellForBrandsVC.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor =  .clear
        
        
//        if let group = menu.groups.first?.groups, group.count > 0 {
//            selectedGroup = group.first
//        } else {
//            selectedGroup = menu.groups.first
//        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // refactor getCartObservser
//        managerFB.getCartProduct { [weak self] cartProducts in
//            self?.cartProducts = cartProducts
//        }
        
        getCartProducts { cartProducts in
            self.cartProducts = cartProducts
        }
        
        if let _ = pathRefBrandVC {
            managerFB.getBrand(searchBrand: computerPathBrandVC) { [weak self] garderob in
                self?.productsForCategory = garderob
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // refactor getCartObservser
//        managerFB.removeObserverForCartProductsUser()
        if let _ = pathRefBrandVC {
            managerFB.removeObserverBrandProduct(searchBrand: computerPathBrandVC)
        }
        
//        if let searchBrand = pathRefBrandVC {
//            managerFB.removeObserverBrandProduct(searchBrand: searchBrand)
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let guide = view.safeAreaLayoutGuide
        let heightSafeArea = guide.layoutFrame.size.height
        let xProcent = heightSafeArea/100 * 10
        heightCollectionView = heightSafeArea - xProcent
        heightGroupsCV.constant = xProcent

    }
    
    deinit {
        print("deinit deinit deinit BrandsViewController ")
    }
    
    // Если свайпом листаем collectionView - премещаем selectedGroup в groupsCollectionView и меняем titleVC
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            let cells = collectionView.visibleCells
            
            if let cell = cells.first, let indexPath = collectionView.indexPath(for: cell) {
//                selectedGroup = menu.groups.first?.groups?[indexPath.item]
                indexGroupsCollectionView = indexPath.item
                selectedGroup = productsForCategory?.groups[indexPath.item]
                groupsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                groupsCollectionView.reloadData()
            }
        }
    }
    
    private func getCartProducts(completionHandler: @escaping ([PopularProduct]) -> Void) {
        guard let tabBarVCs = tabBarController?.viewControllers else { return }
        tabBarVCs.forEach { (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.viewControllers.first as? NewHomeViewController {
                    self.arrayPin = homeVC.placesMap
//                    self.magazinesArray = homeVC.magazines
                    completionHandler(homeVC.cartProducts)
                }
            }
        }
    }
    
//    private func bildingPathRef(path: String) -> String {
//        let gender = defaults.string(forKey: "gender") ?? "Woman"
//        let path = "Brands\(gender)"
//        let fullPath = "\(path)/\(pathRefBrandVC)"
//        return fullPath
//    }
}


extension BrandsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productsForCategory?.groups.count ?? 0
//        menu.groups.first?.groups?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == groupsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
//            let groupName = menu.groups.first?.groups?[indexPath.item].name
            let groupName = productsForCategory?.groups[indexPath.item].name
            let boolName = groupName == selectedGroup?.name
            cell.setupCell(groupName: groupName!, isSelected: boolName)
            return cell
        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellForBrandsVC", for: indexPath) as! ProductCellForBrandsVC
            cell.delegate = self
//            let product = menu.groups.first?.groups?[indexPath.item].product
            let product = productsForCategory?.groups[indexPath.item].product
            cell.setupCell(product: product!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == groupsCollectionView {
            //            let groupName = menu.groups.first!.groups![indexPath.item].name
            let groupName = productsForCategory?.groups[indexPath.item].name ?? ""
//            UIFont.systemFont(ofSize: 20)
            let width = groupName.widthOfString(usingFont: UIFont.systemFont(ofSize: 20, weight: .bold))
            return CGSize(width: width + 20, height: collectionView.frame.height/2)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 10, height: heightCollectionView)
        }
    }
    
    
    // между cell 10 теперь отступы(справо и лева)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // что бы центровка не сбивалась выставим отступы и вычтим их из UIScreen.main.bounds.width - 10
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    
        if collectionView == groupsCollectionView {
            
//            selectedGroup = menu.groups.first?.groups?[indexPath.item]
            selectedGroup = productsForCategory?.groups[indexPath.item]
            indexGroupsCollectionView = indexPath.item
            groupsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            groupsCollectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    
}

extension BrandsViewController: ProductCellDelegtate {
    
    func didSelectProduct(product: PopularProduct) {
        
//        let productVC = UIStoryboard.vcById("ProductViewController") as! ProductViewController
        let productVC = NewProductViewController()
        
        var placesArray: [Places] = []
        let malls = product.malls
        
        arrayPin.forEach { (places) in
            if malls.contains(places.title ?? "") {
                placesArray.append(places)
            }
        }
//        print("cartProducts.forEach - \(cartProducts.count)")
        cartProducts.forEach { (addedProduct) in
           
            if addedProduct.model == product.model {
//                print("addedProduct.model - \(addedProduct.model)")
//                print("model.model - \(model.model)")
                productVC.isAddedToCard = true
            }
        }
        
        productVC.arrayPin = placesArray
        productVC.productModel = product
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
    
    
}

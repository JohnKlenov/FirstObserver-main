//
//  MallViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit

//collectionViewLayout.register(HeaderProductView.self, forSupplementaryViewOfKind: "HeaderProduct", withReuseIdentifier: HeaderProductView.headerIdentifier)

class MallsViewController: ParentNetworkViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    var hightCellVC: CGFloat!

    var arrayPins: [Places] = []
    var mallsModel: [PreviewCategory] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var brandsModel: [PreviewCategory] = []
    var modelMVCDict = [String:[PreviewCategory]]() {
        didSet {
            if modelMVCDict.count == 2 {
                if let  mallsModel = modelMVCDict["Malls"] {
                    self.mallsModel = mallsModel
                }
                if let brandsModel = modelMVCDict["Brands"] {
                    self.brandsModel = brandsModel
                }
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }
        }
    }

    let managerFB = FBManager.shared
    let defaults = UserDefaults.standard
    private var currentGender = ""
    
    // CloudFirestore
    var shops:[String:[Shop]] = [:]
    
    // MARK: life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = R.Strings.TabBarController.Malls.title
        view.backgroundColor = R.Colors.systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        hightCellVC = (collectionView.frame.height/3)*0.86
        collectionView.register(HeaderMallsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderMallsCollectionReusableView.headerIdentifier)
        
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        currentGender = gender
        getDataFB(path: gender)
        configureActivityView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // refactor getCartObservser
//        managerFB.removeObserverForCartProductsUser()
        switchGender()
        getPlacesHVC()
        
//        print("managerFB.avatarRef - \(String(describing: managerFB.avatarRef))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    // MARK: - another methods
    
    
    private func getPlacesHVC() {
        
        guard let tabBarVCs = tabBarController?.viewControllers else {return}
        for vc in tabBarVCs {
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.viewControllers.first as? NewHomeViewController {
                    self.arrayPins = homeVC.placesMap
//                    self.shops = homeVC.shops
                }
            }
        }
    }
    
    private func getDataFB(path: String) {
        
        managerFB.getPreviewMallsGenderMVC(path: path) { malls in
            
            var mallsItem:[PreviewCategory] = []
            malls.forEach { item in
                if let mall = item.malls {
                    mallsItem.append(mall)
                }
            }
            self.modelMVCDict["Malls"] = mallsItem
        }
        
        managerFB.getPreviewBrandsGenderMVC(path: path) { brands in
            
            var brandsItem:[PreviewCategory] = []
            brands.forEach { item in
                if let brand = item.brands {
                    brandsItem.append(brand)
                }
            }
            self.modelMVCDict["Brands"] = brandsItem
        }
    }
    
    func switchGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        if currentGender != gender {
            configureActivityView()
            managerFB.removeObserverPreviewMallsGenderMVC(path: currentGender)
            managerFB.removeObserverPreviewBrandsGenderMVC(path: currentGender)
            modelMVCDict = [:]
            currentGender = gender
            getDataFB(path: currentGender)
        }
    }
}

extension MallsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mallsModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MallCollectionViewCell", for: indexPath) as! MallCollectionViewCell
        cell.configureCell(model: mallsModel[indexPath.item], currentFrame: CGSize(width: collectionView.frame.width - 20, height: hightCellVC))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: hightCellVC)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let mallVC = UIStoryboard.vcById("MallViewController") as? MallViewController

        let mallVC = UIStoryboard.vcById("NewMallViewController") as? NewMallViewController
        if let mallVC = mallVC {
            mallVC.arrayPin = self.arrayPins
            mallVC.brandsMall = self.brandsModel
            if let refPath = mallsModel[indexPath.item].brand {
                mallVC.refPath = refPath
            }
            self.navigationController?.pushViewController(mallVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderMallsCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderMallsCollectionReusableView
        headerView.delegate = self
        headerView.configureCell()
        return headerView
    }
}

extension MallsViewController: HeaderMallsCollectionViewDelegate {
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

//private func getDataHVC() {
//
//    guard let tabBarVCs = tabBarController?.viewControllers else {return}
//
//    for vc in tabBarVCs {
//
//        if let nc = vc as? UINavigationController {
//            if let homeVC = nc.topViewController as? NewHomeViewController {
////                    homeVC.
//
//                self.arrayPins = homeVC.placesMap
//                let mallsSection = homeVC.modelHomeViewControllerDict.filter({$0.value.section == "Malls"})
//                var malls:[PreviewCategory] = []
//                if let items = mallsSection.first?.value.items {
//                    items.forEach { item in
//                        if let mall = item.malls {
//                            malls.append(mall)
//                        }
//                    }
//                    self.mallsModel = malls
//                }
//
//                let brandsSection = homeVC.modelHomeViewControllerDict.filter({$0.value.section == "Brands"})
//                var brands:[PreviewCategory] = []
//                if let items = brandsSection.first?.value.items {
//                    items.forEach { item in
//                        if let brand = item.brands {
//                            brands.append(brand)
//                        }
//                    }
//                    self.brandsModel = brands
//                }
//            }
//        }
//    }
//}

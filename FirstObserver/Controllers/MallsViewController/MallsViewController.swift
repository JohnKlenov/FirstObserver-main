//
//  MallViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit

class MallsViewController: UIViewController {
    
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hightCellVC: CGFloat!

    var arrayPins: [PlacesTest] = []
    var mallsModel: [PreviewCategory] = []
    var brandsModel: [PreviewCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = R.Strings.TabBarController.Malls.title
        view.backgroundColor = R.Colors.systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        hightCellVC = (collectionView.frame.height/3)*0.86
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        getDataHVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func getDataHVC() {
        
        guard let tabBarVCs = tabBarController?.viewControllers else {return}
        
        for vc in tabBarVCs {
            
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.topViewController as? NewHomeViewController {
//                    homeVC.
                    
                    self.arrayPins = homeVC.placesMap
                    let mallsSection = homeVC.modelHomeViewControllerDict.filter({$0.value.section == "Malls"})
                    var malls:[PreviewCategory] = []
                    if let items = mallsSection.first?.value.items {
                        items.forEach { item in
                            if let mall = item.malls {
                                malls.append(mall)
                            }
                        }
                        self.mallsModel = malls
                    }
                    
                    let brandsSection = homeVC.modelHomeViewControllerDict.filter({$0.value.section == "Brands"})
                    var brands:[PreviewCategory] = []
                    if let items = brandsSection.first?.value.items {
                        items.forEach { item in
                            if let brand = item.brands {
                                brands.append(brand)
                            }
                        }
                        self.brandsModel = brands
                    }
                }
            }
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
   
}



//
//  ViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit


protocol CartViewDelegate: AnyObject {
    func goToCatalogVC()
}

class CartViewController: UIViewController {
    
    var managerFB = FBManager.shared
    @IBOutlet weak var tableView: UITableView!
    
    var model: [Product]!
    var arrayPlaces: [PlacesTest] = []
    var addedInCartProducts: [PopularProduct] = [] {
        didSet {
            print("didSet addedInCartProducts")
            // true if empty
            if addedInCartProducts.count == 0 {
                print("addedInCartProducts.count == 0")
//                tableView.reloadData()
                tableView.isHidden = true
                cartView.isHidden = false
//                visibleCartView()
                animateCartView()
            } else {
                print("addedInCartProducts.count != 0")
//                tableView.reloadData()
                tableView.isHidden = false
                cartView.isHidden = true
            }
        }
    }
    var cartView: CartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
        setupHeaderView()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        // new
        visibleCartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CartViewController viewWillAppear")
        print("cartView - \(String(describing: cartView))")
        getFetchDataHVC()
    }
    
    private func setupCartViewConstraints() {
        cartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), cartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10), cartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    func setupHeaderView() {
        
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width , height: 5))
        headView.backgroundColor = .white
//        headView.backgroundColor = .orange
        tableView.tableHeaderView = headView
    }
    
    private func animateCartView() {
        cartView.alpha = 0
//        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
//            self.cartView.alpha = 1
//        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear) { [weak self] in
            self?.cartView.alpha = 1
        }
    }
    
    private func visibleCartView() {
//        tableView.isHidden = true
        cartView = CartView()
        cartView.delegate = self
        view.addSubview(cartView)
        setupCartViewConstraints()
    }
    
//    private func getFetchDataHVC() {
//
//        guard let tabBarVCs = tabBarController?.viewControllers else { return }
//
//        tabBarVCs.forEach { [weak self] (vc) in
//            if let nc = vc as? UINavigationController {
//                if let homeVC = nc.topViewController as? NewHomeViewController {
//
//                    if homeVC.cardProducts.count == 0 {
//                        print("if homeVC.cardProducts.count == 0")
//                        // видимо он был не нил и таблица осталась видна tableView.isHidden = false
//                        if self?.cartView == nil {
//                            print("if self?.cartView == nil")
//                            self?.visibleCartView()
//                        }
//                    } else {
//                        print("homeVC.cardProducts.count != 0")
//                        if self?.cartView != nil {
//                            print("if self?.cartView != nil {")
//                            self?.cartView.removeFromSuperview()
//                        }
//                        self?.tableView.isHidden = false
//                        self?.arrayPlaces = homeVC.placesMap
//                        self?.addedInCartProducts = homeVC.cardProducts
//                        self?.tableView.reloadData()
//                    }
//                }
//            }
//        }
//    }
    
    private func getFetchDataHVC() {
       
        guard let tabBarVCs = tabBarController?.viewControllers else { return }
       
        tabBarVCs.forEach { [weak self] (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.topViewController as? NewHomeViewController {
                    
                    self?.addedInCartProducts = homeVC.cardProducts
                    self?.arrayPlaces = homeVC.placesMap
                    tableView.reloadData()
                    
                   
//                    if homeVC.cardProducts.count == 0 {
//                        print("if homeVC.cardProducts.count == 0")
//                        // видимо он был не нил и таблица осталась видна tableView.isHidden = false
//                        if self?.cartView == nil {
//                            print("if self?.cartView == nil")
//                            self?.visibleCartView()
//                        }
//                    } else {
//                        print("homeVC.cardProducts.count != 0")
//                        if self?.cartView != nil {
//                            print("if self?.cartView != nil {")
//                            self?.cartView.removeFromSuperview()
//                        }
//                        self?.tableView.isHidden = false
//                        self?.arrayPlaces = homeVC.placesMap
//                        self?.addedInCartProducts = homeVC.cardProducts
//                        self?.tableView.reloadData()
//                    }
                }
            }
        }
    }

    
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedInCartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configureCell(model: addedInCartProducts[indexPath.row])
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = addedInCartProducts[indexPath.row]
            // удаление должен делать FBManager
//            product.refProduct.removeValue()
            managerFB.removeProduct(refProduct: product.refProduct)
            addedInCartProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
//            addedInCartProducts.remove(at: indexPath.row)
//            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var placesArray: [PlacesTest] = []
        let product = addedInCartProducts[indexPath.row]
        let malls = product.malls
        
        arrayPlaces.forEach { (places) in
            if malls.contains(places.title ?? "") {
                placesArray.append(places)
            }
        }
        
        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        
        addedInCartProducts.forEach { (addedProduct) in
            if addedProduct.model == product.model {
                productVC.isAddedToCard = true
            }
        }
        
        productVC.arrayPin = placesArray
        productVC.fireBaseModel = product
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}

extension CartViewController: CartViewDelegate {
    func goToCatalogVC() {
        let catalogVC = UIStoryboard.vcById("CatalogViewController") as! CatalogViewController
        navigationController?.pushViewController(catalogVC, animated: true)
        print("goToCatalogVC")
    }
    
    
}


//import Firebase
//import FirebaseAuth

//    var heightCell: CGFloat!
//    var imageWidth: CGFloat!
//    private lazy var ref: DatabaseReference? = {
//        guard let uid = Auth.auth().currentUser?.uid else { return nil }
//        let ref = Database.database().reference(withPath: "usersAccaunt/\(uid)/AddedProducts")
//        return ref
//    }()

//        heightCell = self.tableView.frame.height/7
//        imageWidth = heightCell - 30
//        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "CartTableViewCell")

//        ref?.observe(.value) { (snapshot) in
//
//            var arrayProduct = [PopularProduct]()
//
//            for item in snapshot.children {
//                let addedProduct = item as! DataSnapshot
//
//                var arrayMalls = [String]()
//                var arrayRefe = [String]()
//                for childItem in addedProduct.children {
//                    let childItem = childItem as! DataSnapshot
//                    switch childItem.key {
//                    case "malls":
//                        for it in childItem.children {
//                            let item = it as! DataSnapshot
//                            if let refDictionary = item.value as? String {
//                                arrayMalls.append(refDictionary)
//                            }
//                        }
//                    case "refArray":
//                        for it in childItem.children {
//                            let item = it as! DataSnapshot
//                            if let refDictionary = item.value as? String {
//                                arrayRefe.append(refDictionary)
//                            }
//                        }
//                    default:
//                        break
//                    }
//                }
//                //
//                let product = PopularProduct(snapshot: addedProduct, refArray: arrayRefe, malls: arrayMalls)
//                arrayProduct.append(product)
//            }
//            self.addedInCartProducts = arrayProduct
//            self.tableView.reloadData()
//        }

//        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
//        cell.configureCell(model: addedInCartProducts[indexPath.row], imageWidth: imageWidth)

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return heightCell
//    }
    

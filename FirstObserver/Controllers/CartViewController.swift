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
    var isAnimate = false
    // bug когда удаляем последний product анимации удаления не видно(потому что сразу tableView.isHidden = true)
    var addedInCartProducts: [PopularProduct] = [] {
        didSet {
            // true if empty
            if addedInCartProducts.count == 0 {
                
                if isAnimate {
                    isAnimate.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.tableView.isHidden = true
                        self.animateCartView()
                    }
                } else {
                    self.tableView.isHidden = true
                    self.cartView.isHidden = false
                }
              
            } else {
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
        getFetchDataHVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.cartView.isHidden = true
    }
    
    private func setupCartViewConstraints() {
//        cartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        cartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cartView.centerXAnchor.constraint(equalTo: view.centerXAnchor), cartView.centerYAnchor.constraint(equalTo: view.centerYAnchor), cartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10), cartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    func setupHeaderView() {
        
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width , height: 5))
        headView.backgroundColor = .white
//        headView.backgroundColor = .orange
        tableView.tableHeaderView = headView
    }
    
    private func animateCartView() {
        cartView.alpha = 0
        cartView.isHidden = true
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear) { [weak self] in
            self?.cartView.isHidden = false
            self?.cartView.alpha = 1
        }
    }
    
    private func visibleCartView() {
        cartView = CartView()
        cartView.delegate = self
        cartView.isHidden = true
        view.addSubview(cartView)
        
        setupCartViewConstraints()
    }
    
    private func getFetchDataHVC() {
       
        guard let tabBarVCs = tabBarController?.viewControllers else { return }
       
        tabBarVCs.forEach { [weak self] (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.topViewController as? NewHomeViewController {
                    
                    self?.addedInCartProducts = homeVC.cardProducts
                    self?.arrayPlaces = homeVC.placesMap
                    tableView.reloadData()
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
            isAnimate = addedInCartProducts.count == 1 ? true : false
            managerFB.removeProduct(refProduct: product.refProduct)
            addedInCartProducts.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
        
        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewProductViewController") as! NewProductViewController
        
        addedInCartProducts.forEach { (addedProduct) in
            if addedProduct.model == product.model {
                productVC.isAddedToCard = true
            }
        }
        
        productVC.arrayPin = placesArray
        productVC.productModel = product
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}

extension CartViewController: CartViewDelegate {
    func goToCatalogVC() {
        let catalogVC = UIStoryboard.vcById("CatalogViewController") as! CatalogViewController
        navigationController?.pushViewController(catalogVC, animated: true)
    }
    
    
}



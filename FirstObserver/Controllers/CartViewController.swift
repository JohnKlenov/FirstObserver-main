//
//  ViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit


//protocol CartViewDelegate: AnyObject {
//    func didTapCatalogButton()
//}

class CartViewController: UIViewController {
    
    var managerFB = FBManager.shared
    @IBOutlet weak var tableView: UITableView!
    
    var model: [Product]!
    var arrayPlaces: [PlacesTest] = []
    var isAnimate = false
    // bug когда удаляем последний product анимации удаления не видно(потому что сразу tableView.isHidden = true)
    var addedInCartProducts: [PopularProduct] = []
//    {
//        didSet {
//            // true if empty
//            if addedInCartProducts.count == 0 {
//                print("addedInCartProducts.count == 0")
//                if isAnimate {
//                    print("isAnimate = true")
//                    isAnimate.toggle()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        self.tableView.isHidden = true
//                        self.animateCartView()
//                    }
//                } else {
//                    print("isAnimate = false")
//                    self.tableView.isHidden = true
//                    self.cartViewIsEmpty.isHidden = false
//                }
//
//            } else {
//                print("addedInCartProducts.count != 0")
//                tableView.isHidden = false
//                cartViewIsEmpty.isHidden = true
//            }
//        }
//    }
    var cartViewIsEmpty: CartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.backgroundWhiteLith
        title = R.Strings.TabBarController.Cart.title
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = R.Colors.backgroundWhiteLith
        setupHeaderView()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        // new
        visibleCartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlacesMap()
        configureUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.cartView.isHidden = true
    }
    
    private func configureUI() {
        
        managerFB.userIsAnonymously { [weak self] (isAnonymously) in
            if isAnonymously {
                print("isAnonymously = true")
                self?.cartViewIsEmpty.signInSignUpButton.isHidden = false
            } else {
                print("isAnonymously = false")
                self?.cartViewIsEmpty.signInSignUpButton.isHidden = true
            }
        }
        
        managerFB.getCardProduct { [weak self] cartProduct in
            print("managerFB.getCardProduct { [weak self]")
            //            guard let self = self else {return}
            self?.addedInCartProducts = cartProduct
            self?.tableView.reloadData()
            
            if let isAnimate = self?.isAnimate {
                if self?.addedInCartProducts.count == 0 {
                    print("addedInCartProducts.count == 0")
                    if isAnimate  {
                        print("isAnimate = true")
                        self?.isAnimate.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self?.tableView.isHidden = true
                            self?.animateCartView()
                        }
                    } else {
                        print("isAnimate = false")
                        self?.tableView.isHidden = true
                        self?.cartViewIsEmpty.isHidden = false
                    }
                    
                } else {
                    print("addedInCartProducts.count != 0")
                    self?.tableView.isHidden = false
                    self?.cartViewIsEmpty.isHidden = true
                }
            }
            
        }
    }
    
    private func setupCartViewConstraints() {
//        cartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        cartViewIsEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cartViewIsEmpty.centerXAnchor.constraint(equalTo: view.centerXAnchor), cartViewIsEmpty.centerYAnchor.constraint(equalTo: view.centerYAnchor), cartViewIsEmpty.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10), cartViewIsEmpty.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    func setupHeaderView() {
        
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width , height: 5))
        headView.backgroundColor = .clear
        tableView.tableHeaderView = headView
    }
    
    private func animateCartView() {
        cartViewIsEmpty.alpha = 0
        cartViewIsEmpty.isHidden = true
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear) { [weak self] in
            self?.cartViewIsEmpty.isHidden = false
            self?.cartViewIsEmpty.alpha = 1
        }
    }
    
    private func visibleCartView() {
        cartViewIsEmpty = CartView()
        cartViewIsEmpty.delegate = self
        cartViewIsEmpty.isHidden = true
        view.addSubview(cartViewIsEmpty)
        
        setupCartViewConstraints()
    }
    
        private func getPlacesMap() {
    
            guard let tabBarVCs = tabBarController?.viewControllers else { return }
    
            tabBarVCs.forEach { [weak self] (vc) in
                if let nc = vc as? UINavigationController {
                    if let homeVC = nc.topViewController as? NewHomeViewController {
                        self?.arrayPlaces = homeVC.placesMap
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
//            managerFB.removeProduct(refProduct: product.refProduct)
            addedInCartProducts.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            managerFB.removeProduct(refProduct: product.refProduct)
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

extension CartViewController: CartViewControllerDelegate {
    
    func didTaplogInButton() {
        
        let signInVC = NewSignInViewController()
        signInVC.cardProducts = addedInCartProducts
        signInVC.profileDelegate = self
        signInVC.presentationController?.delegate = self
        present(signInVC, animated: true, completion: nil)
    }
    
    func didTapCatalogButton() {
        let catalogVC = UIStoryboard.vcById("CatalogViewController") as! CatalogViewController
        navigationController?.pushViewController(catalogVC, animated: true)
    }
}

extension CartViewController: SignInViewControllerDelegate {
    func userIsPermanent() {
        isAnimate = false
        print("userIsPermanent")
        configureUI()
    }
}





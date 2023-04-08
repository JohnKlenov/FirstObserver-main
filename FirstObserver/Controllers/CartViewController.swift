//
//  ViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit

final class CartViewController: UIViewController {
    
    private var managerFB = FBManager.shared
    @IBOutlet weak var tableView: UITableView!
    
    private var model: [Product]!
    private var arrayPlaces: [PlacesTest] = []
    private var isAnimateCartView = false
    private var addedInCartProducts: [PopularProduct] = []
    private var cartViewIsEmpty: CartView!
    
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.backgroundWhiteLith
        title = R.Strings.TabBarController.Cart.title
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = R.Colors.backgroundWhiteLith
        createHeaderTableView()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        createCartViewIsEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear(animated)")
        getPlacesMap()
        configureUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear(animated)")
        managerFB.removeObserverForUserAccaunt()
        addedInCartProducts = []
    }
    
  
    // MARK: - Another methods
   
    private func configureUI() {
        
        managerFB.userIsAnonymously { [weak self] (isAnonymously) in
            if isAnonymously {
                self?.cartViewIsEmpty.signInSignUpButton.isHidden = false
            } else {
                self?.cartViewIsEmpty.signInSignUpButton.isHidden = true
            }
        }
        
        managerFB.getCartProduct { [weak self] cartProduct in
            print("managerFB.getCardProduct { [weak self] ")
            
            self?.addedInCartProducts = cartProduct
            print("cartProduct - \(cartProduct.count)")
            self?.tableView.reloadData()
            
            if let isAnimate = self?.isAnimateCartView {
                if self?.addedInCartProducts.count == 0 {
                    if isAnimate  {
                        self?.isAnimateCartView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self?.tableView.isHidden = true
                            self?.animateCartView()
                        }
                    } else {
                        self?.tableView.isHidden = true
                        self?.cartViewIsEmpty.isHidden = false
                    }
                    
                } else {
                    self?.tableView.isHidden = false
                    self?.cartViewIsEmpty.isHidden = true
                }
            }
            
        }
    }
    
    private func setupCartViewConstraints() {
        cartViewIsEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cartViewIsEmpty.centerXAnchor.constraint(equalTo: view.centerXAnchor), cartViewIsEmpty.centerYAnchor.constraint(equalTo: view.centerYAnchor), cartViewIsEmpty.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10), cartViewIsEmpty.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    func createHeaderTableView() {
        
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
    
    private func createCartViewIsEmpty() {
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


// MARK: - UITableViewDelegate, UITableViewDataSource
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
            isAnimateCartView = addedInCartProducts.count == 1 ? true : false
            addedInCartProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        signInVC.delegate = self
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
        managerFB.removeObserverForUserAccaunt()
        configureUI()
        
//        isAnimateCartView = false
        print("userIsPermanent")
//        configureUI()
    }
}





//
//  ViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit

final class CartViewController: ParentNetworkViewController {
    
    private var managerFB = FBManager.shared
    @IBOutlet weak var tableView: UITableView!
    
    private var model: [Product]!
    private var arrayPlaces: [PlacesTest] = []
    private var isAnonymouslyUser = false
    private var cartProducts: [PopularProduct] = []
    private var cartViewIsEmpty: CartView?
    
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // refactor getCartObservser
        //        configureActivityView()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = R.Colors.systemBackground
        title = R.Strings.TabBarController.Cart.title
        
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
//        tableView.estimatedRowHeight = 10
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        resetBadgeValue()
    }
    
    private func resetBadgeValue() {
        if let items = self.tabBarController?.tabBar.items {
            items[3].badgeValue = nil
        }
    }
    
    private func createCartViewIsEmpty() {
        cartViewIsEmpty = CartView()
        cartViewIsEmpty?.delegate = self
        cartViewIsEmpty?.signInSignUpButton.isHidden = isAnonymouslyUser ? false : true
    }
    
    private func updateData() {
        managerFB.userIsAnonymously { [weak self] (isAnonymously) in
            self?.isAnonymouslyUser = isAnonymously
            self?.getDataFromHVC { products in
                self?.cartProducts = products
                self?.tableView.reloadData()
            }
        }
    }
    
    private func getDataFromHVC(completionHandler: @escaping ([PopularProduct]) -> Void) {
        guard let tabBarVCs = tabBarController?.viewControllers else {
            return }
        tabBarVCs.forEach { [weak self] (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.viewControllers.first as? NewHomeViewController {
                    self?.arrayPlaces = homeVC.placesMap
                    completionHandler(homeVC.cartProducts)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cartProducts.count == 0 {
            createCartViewIsEmpty()
            tableView.setEmptyView(emptyView: cartViewIsEmpty ?? UIView())

        } else {
            tableView.backgroundView = nil
            cartViewIsEmpty = nil
        }
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configureCell(model: cartProducts[indexPath.row])
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = cartProducts[indexPath.row]
//            isAnimateCartView = cartProducts.count == 1 ? true : false
            cartProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            managerFB.removeProduct(refProduct: product.refProduct)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var placesArray: [PlacesTest] = []
        let product = cartProducts[indexPath.row]
        let malls = product.malls
        
        arrayPlaces.forEach { (places) in
            if malls.contains(places.title ?? "") {
                placesArray.append(places)
            }
        }
        
        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewProductViewController") as! NewProductViewController
        
        cartProducts.forEach { (addedProduct) in
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
        signInVC.cartProducts = cartProducts
        signInVC.delegate = self
        signInVC.presentationController?.delegate = self
        present(signInVC, animated: true, completion: nil)
    }
    
    func didTapCatalogButton() {
        tabBarController?.selectedIndex = 1
    }
}

extension CartViewController: SignInViewControllerDelegate {
    func userIsPermanent() {
        // refactor getCartObservser
//        managerFB.removeObserverForCartProductsUser()
        configureActivityView()
        managerFB.getCartProductOnce { cartProducts in
            self.managerFB.userIsAnonymously { [weak self] (isAnonymously) in
                self?.isAnonymouslyUser = isAnonymously
                self?.cartProducts = cartProducts
                self?.activityView.stopAnimating()
                self?.activityView.removeFromSuperview()
                self?.tableView.reloadData()
            }
        }
    }
}

extension UITableView {
    
    func setEmptyView(emptyView: UIView) {
        
        let containerEmpty = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        containerEmpty.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        containerEmpty.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        containerEmpty.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        containerEmpty.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 10).isActive = true
        containerEmpty.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -10).isActive = true
        
        backgroundView = containerEmpty
        separatorStyle = .none
    }
}

//extension UIView {
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        for subview in self.subviews {
//            subview.layoutSubviews()
//        }
//
//        // Add breakpoint here ↓
//        if hasAmbiguousLayout {
//            UIView.alertForUnsatisfiableConstraints(in: self.superview)
//        }
//    }
//}
//
//extension UIView {
//    static func alertForUnsatisfiableConstraints(in view: UIView?) {
//        DispatchQueue.main.async {
//            guard let view = view else {
//                return
//            }
//            view.backgroundColor = .red
//
//            let alertController = UIAlertController(title: "Unsatisfiable Constraints!", message: "Warning! \(view) has unsatisfiable constraints", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            if let rootViewController = view.window?.rootViewController {
//                rootViewController.present(alertController, animated: true, completion: nil)
//            }
//        }
//    }
//}










//        getPlacesMap()
//        getCartProducts { products in
//            print("CartViewController  getCartProducts ")
//            self.cartProducts = products
//            self.tableView.reloadData()
//        }
        
        // refactor getCartObservser
        //        managerFB.removeObserverForCartProductsUser()
        //        managerFB.getCartProduct { [weak self] cartProducts in
        //            self?.cartProducts = cartProducts
        //            self?.activityView.stopAnimating()
        //            self?.activityView.removeFromSuperview()
        //            self?.tableView.reloadData()
        //            if cartProducts.count == 0 {
        //                self?.createCartViewIsEmpty()
        //                self?.tableView.setEmptyView(emptyView: self?.cartViewIsEmpty ?? UIView())
        //            } else {
        //                self?.tableView.backgroundView = nil
        //                self?.cartViewIsEmpty = nil
        //            }
        ////                        self?.tableView.reloadData()
        //        }
        
//        managerFB.userIsAnonymously { [weak self] (isAnonymously) in
//            print("CartViewController  managerFB.userIsAnonymously ")
//            self?.isAnonymouslyUser = isAnonymously
//            self?.getDataFromHVC { products in
//                print("CartViewController  getCartProducts ")
//                self?.cartProducts = products
//                self?.tableView.reloadData()
//            }
//        }

//    private func getPlacesMap() {
//        guard let tabBarVCs = tabBarController?.viewControllers else { return }
//        tabBarVCs.forEach { [weak self] (vc) in
//            if let nc = vc as? UINavigationController {
//                if let homeVC = nc.topViewController as? NewHomeViewController {
//                    self?.arrayPlaces = homeVC.placesMap
//                }
//            }
//        }
//    }

// MARK: - old implemenation -


//    private var managerFB = FBManager.shared
//    @IBOutlet weak var tableView: UITableView!
//
//    private var model: [Product]!
//    private var arrayPlaces: [PlacesTest] = []
//    private var isAnimateCartView = false
//    private var cartProducts: [PopularProduct] = []
//    private var cartViewIsEmpty: CartView!
//
//
//    // MARK: - Life cycle methods
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = R.Colors.systemBackground
//        title = R.Strings.TabBarController.Cart.title
//        navigationController?.navigationBar.prefersLargeTitles = true
//        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
//        tableView.estimatedRowHeight = 10
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.backgroundColor = .clear
////        createHeaderTableView()
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        createCartViewIsEmpty()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("CartVC viewWillAppear")
//        managerFB.removeObserverForCartProductsUser()
//        getPlacesMap()
//        configureUI()
//
//    }
//
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("CartVC viewWillDisappear")
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("CartVC viewDidDisappear")
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//
//    // MARK: - Another methods
//
//    private func configureUI() {
//
//        managerFB.userIsAnonymously { [weak self] (isAnonymously) in
//            if isAnonymously {
//                self?.cartViewIsEmpty.signInSignUpButton.isHidden = false
//            } else {
//                self?.cartViewIsEmpty.signInSignUpButton.isHidden = true
//            }
//        }
//
//        managerFB.getCartProduct { [weak self] cartProducts in
//            print(" managerFB.getCartProduct { [weak self] cartProducts in")
//            self?.cartProducts = cartProducts
//            self?.tableView.reloadData()
//
//            if let isAnimate = self?.isAnimateCartView {
//                if self?.cartProducts.count == 0 {
//                    if isAnimate  {
//                        self?.isAnimateCartView.toggle()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
//                            self?.tableView.isHidden = true
//                            self?.animateCartView()
//                        }
//                    } else {
//                        self?.tableView.isHidden = true
//                        self?.cartViewIsEmpty.isHidden = false
//                    }
//
//                } else {
//                    self?.tableView.isHidden = false
//                    self?.cartViewIsEmpty.isHidden = true
//                }
//            }
//
//        }
//    }
//
//    private func setupCartViewConstraints() {
//        cartViewIsEmpty.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([cartViewIsEmpty.centerXAnchor.constraint(equalTo: view.centerXAnchor), cartViewIsEmpty.centerYAnchor.constraint(equalTo: view.centerYAnchor), cartViewIsEmpty.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10), cartViewIsEmpty.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
//    }
//
//    func createHeaderTableView() {
//
//        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width , height: 5))
//        headView.backgroundColor = .clear
//        tableView.tableHeaderView = headView
//    }
//
//    private func animateCartView() {
//        // hz
////        managerFB.removeObserverForCartProductsUser()
//        cartViewIsEmpty.alpha = 0
//        cartViewIsEmpty.isHidden = true
//        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear) { [weak self] in
//            self?.cartViewIsEmpty.isHidden = false
//            self?.cartViewIsEmpty.alpha = 1
//        }
//    }
//
//    private func createCartViewIsEmpty() {
//        cartViewIsEmpty = CartView()
//        cartViewIsEmpty.delegate = self
//        cartViewIsEmpty.isHidden = true
//        view.addSubview(cartViewIsEmpty)
//        setupCartViewConstraints()
//    }
//
//    private func getPlacesMap() {
//        guard let tabBarVCs = tabBarController?.viewControllers else { return }
//        tabBarVCs.forEach { [weak self] (vc) in
//            if let nc = vc as? UINavigationController {
//                if let homeVC = nc.topViewController as? NewHomeViewController {
//                    self?.arrayPlaces = homeVC.placesMap
//                }
//            }
//        }
//    }


//// MARK: - UITableViewDelegate, UITableViewDataSource
//extension CartViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cartProducts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
//        cell.configureCell(model: cartProducts[indexPath.row])
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let product = cartProducts[indexPath.row]
//            isAnimateCartView = cartProducts.count == 1 ? true : false
//            cartProducts.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            managerFB.removeProduct(refProduct: product.refProduct)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        var placesArray: [PlacesTest] = []
//        let product = cartProducts[indexPath.row]
//        let malls = product.malls
//
//        arrayPlaces.forEach { (places) in
//            if malls.contains(places.title ?? "") {
//                placesArray.append(places)
//            }
//        }
//
//        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewProductViewController") as! NewProductViewController
//
//        cartProducts.forEach { (addedProduct) in
//            if addedProduct.model == product.model {
//                productVC.isAddedToCard = true
//            }
//        }
//
//        productVC.arrayPin = placesArray
//        productVC.productModel = product
//        self.navigationController?.pushViewController(productVC, animated: true)
//    }
//
//}
//
//extension CartViewController: CartViewControllerDelegate {
//
//    func didTaplogInButton() {
//
//        let signInVC = NewSignInViewController()
//        signInVC.cartProducts = cartProducts
//        signInVC.delegate = self
//        signInVC.presentationController?.delegate = self
//        present(signInVC, animated: true, completion: nil)
//    }
//
//    func didTapCatalogButton() {
////        let catalogVC = UIStoryboard.vcById("CatalogViewController") as! CatalogViewController
////        navigationController?.pushViewController(catalogVC, animated: true)
//        tabBarController?.selectedIndex = 1
//    }
//}
//
//// think abaut whow implementation this methods
//extension CartViewController: SignInViewControllerDelegate {
//    func userIsPermanent() {
//        managerFB.removeObserverForCartProductsUser()
//        configureUI()
//    }
//}




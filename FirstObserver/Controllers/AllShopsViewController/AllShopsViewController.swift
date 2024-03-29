//
//  AllShopsViewController.swift
//  
//
//  Created by Evgenyi on 31.08.23.
//

import UIKit

class AllShopsViewController: UIViewController {
    
    var shopsModel: [SectionHVC] = [] {
        didSet {
            navController?.stopSpinnerForWindow()
            tableView.reloadData()
            startTimerPlaceholder()
        }
    }
    
    var shopsModelTest: [SectionHVC] = []
    
    var timer: Timer?
    var navController: PlaceholderNavigationController? {
            return self.navigationController as? PlaceholderNavigationController
        }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AllShops"
        view.backgroundColor = R.Colors.systemBackground
        setupTableView()
        setupConstraints()
        navController?.startSpinnerForWindow()
        startTimerView()
    }
    
    private func setupTableView() {
        tableView.register(ShopCell.self, forCellReuseIdentifier: ShopCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    
    private func startTimerView() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.shopsModel = self.shopsModelTest
        }
    }
    
    private func startTimerPlaceholder() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.navController?.showPlaceholder()
            self.startTimerPlaceholderSpiner()
        }
    }
    
    private func startTimerPlaceholderSpiner() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            print("AlertStart")
            self.setupAlertReloadFirstData()
//            self.navController?.startSpinnerForPlaceholder()
//            self.startTimerPlaceholderStopSpiner()
        }
    }
    
    private func startTimerPlaceholderStopSpiner() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.navController?.stopSpinnerForPlaceholder()
            self.navController?.hiddenPlaceholder()
        }
    }
    
    func setupAlertReloadFirstData() {
        let alert = UIAlertController(title: "Error ", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .cancel) {[weak self] _ in
//            self?.reloadingFirstData(forData: forData)
            self?.navController?.startSpinnerForPlaceholder()
            self?.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                // протестируем тут self?.navController?.stopSpinner потому что это по сути одно и то же что и self?.navController?.stopSpinnerForPlaceholder()
                self?.navController?.stopSpinnerForPlaceholder()
                self?.setupAlertReloadFirstData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

extension AllShopsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsModel.first?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopCell
        cell.configureCell(model: shopsModel.first?.items[indexPath.row].brands)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt didSelectRowAt didSelectRowAt")
    }
    
}

//
//  AllShopsViewController.swift
//  
//
//  Created by Evgenyi on 31.08.23.
//

import UIKit

class AllShopsViewController: UIViewController {
    
    var shopsModel: [SectionHVC] = []
    
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

}

extension AllShopsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsModel.first?.items.count ?? 1
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

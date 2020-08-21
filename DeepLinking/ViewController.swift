//
//  ViewController.swift
//  DeepLinking
//
//  Created by trungnghia on 8/21/20.
//  Copyright © 2020 trungnghia. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    // MARK: - Properties
    private let table = UITableView()
    private let data = ["Term", "Privacy", "Contacts"]
    
    private lazy var wordButton: UIButton = {
        let button = createButton("app1")
        button.addTarget(self, action: #selector(didTapWordButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var excelButton: UIButton = {
        let button = createButton("app2")
        button.addTarget(self, action: #selector(didTapExcelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var powerpointButton: UIButton = {
        let button = createButton("app3")
        button.addTarget(self, action: #selector(didTapPowerpointButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    // MARK: - Helpers
    private func configureNavigationBar() {
        navigationItem.title = "Deep Linking"
    }
    
    private func configureUI() {
        view.addSubview(table)
    }
    
    private func configureTableView() {
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.tableFooterView = createFooter()
    }
    
    private func createFooter() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        footer.backgroundColor = .secondarySystemBackground
        
        let stack = UIStackView(arrangedSubviews: [wordButton, excelButton, powerpointButton])
        stack.distribution = .fillEqually
        
        footer.addSubview(stack)
        stack.centerY(inView: footer)
        stack.anchor(left: footer.leftAnchor, right: footer.rightAnchor, paddingLeft: 10, paddingRight: 10)

        return footer
    }
    
    private func createButton(_ imageName: String) -> UIButton {
        let button = UIButton()
        button.setDimensions(height: 100, width: 100)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
    
    // MARK: - Selectors
    @objc private func didTapWordButton() {
        openDeepLink(link: "ms-word://")
    }
    
    @objc private func didTapExcelButton() {
        openDeepLink(link: "ms-excel://")
    }
    
    @objc private func didTapPowerpointButton() {
        openDeepLink(link: "ms-powerpoint://")
    }
    
    private func openDeepLink(link: String) {
        guard let url = URL(string: link) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            // deep link
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Not found app")
            // upsell
            let vc = SKStoreProductViewController()
            
            // id586447913 -- word
            // id586683407 -- excel
            // id586449534 --powerpoint
            
            var id = 586447913
            if link.contains("excel") {
                id = 586683407
            }
            if link.contains("powerpoint") {
                id = 586449534
            }
            vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: id)])
            present(vc, animated: true)
        }
    }

}


// MARK: - TableViewDataSource
extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let selectedData = data[indexPath.row]
        cell.textLabel?.text = selectedData
        return cell
    }
    
    
}


//
//  View.swift
//  VIPER-Remind
//
//  Created by İbrahim Bayram on 4.04.2023.
//

import Foundation
import UIKit
// ViewController
// Talks to -> Presenter
// Class, protocol

protocol AnyView {
    var presenter : AnyPresenter? {get set}
    
    func update(with cryptos: [Crypto])
    func update(with error: String)
}

class CryptoViewController : UIViewController, AnyView {
    var presenter: AnyPresenter?
    var cryptos = [Crypto]()
    // MARK: - PROGRAMMATİCALLY UI DESIGNS
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isHidden = true
        return tableView
    }()
    
    private let messageLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "downloading"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(messageLabel)
        view.backgroundColor = .yellow
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
    }
    // MARK: - END OF UI SETUPS
    //If presenter's response is success, update function being called with crypto list.So, we can define our crypto list and reload our table view in main thread.
    func update(with cryptos: [Crypto]) {
        DispatchQueue.main.async {
            self.cryptos = cryptos
            self.messageLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    //If presenter's response is failure, it gives a raw value of our network error.Then message label shows the cause of error.
    func update(with error: String) {
        DispatchQueue.main.async {
            self.messageLabel.text = error
        }
    }
}
// MARK: - TABLE VIEW SETUP
extension CryptoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cryptos[indexPath.row].currency
        content.secondaryText = cryptos[indexPath.row].price
        cell.contentConfiguration = content
        cell.backgroundColor = .yellow
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
}

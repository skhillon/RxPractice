//
//  BaseViewController.swift
//  ExchangeRates
//
//  Created by Sarthak Khillon on 3/25/19.
//  Copyright © 2019 Sarthak Khillon. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var baseCurrencySymbol = ""
    var targetCurrencySymbol = ""
    
    var currencyDescriptions: [(String, String)] = []
    let alertVC = UIAlertController(title: "Result", message: nil, preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        currencyDescriptions = readCurrencyDescriptions()
    }
    
    func createCurrencyCell(tableView: UITableView, data: [(String, String)], cellId: String, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else {
            return UITableViewCell()
        }
        
        let (symbol, currencyName) = data[indexPath.row]
        cell.textLabel?.text = symbol
        cell.detailTextLabel?.text = currencyName
        
        return cell
    }
    
    private func readCurrencyDescriptions() -> [(String, String)] {
        guard let path = Bundle.main.path(forResource: "CurrencyToSymbol", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
                fatalError("Could not get items!")
        }
        
        // Creates sorted list of tuples: [(symbol, currency)]
        return dict.map { ($0, $1) }.sorted { $0 < $1 }
    }

}

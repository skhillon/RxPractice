//
//  FromViewController.swift
//  ExchangeRates
//
//  Created by Sarthak Khillon on 3/25/19.
//  Copyright © 2019 Sarthak Khillon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FromViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredCurrencies = [(String, String)]()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        searchBar.rx.text.orEmpty
            .subscribe(onNext: { [weak self] query in
                self?.updateResults(using: query.lowercased())
            })
            .disposed(by: bag)
    }
    
    private func updateResults(using query: String) {
        filteredCurrencies = currencyDescriptions.filter {
            $0.0.lowercased().hasPrefix(query) || $0.1.lowercased().hasPrefix(query)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createCurrencyCell(tableView: tableView, data: filteredCurrencies, cellId: "fromCell", indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let symbol = tableView.cellForRow(at: indexPath)?.textLabel?.text else {
            fatalError("wat")
        }
        
        baseCurrencySymbol = symbol
        performSegue(withIdentifier: "targetCurrency", sender: tableView)
    }

}

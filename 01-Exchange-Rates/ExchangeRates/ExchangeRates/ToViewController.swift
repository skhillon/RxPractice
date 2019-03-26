//
//  ToViewController.swift
//  ExchangeRates
//
//  Created by Sarthak Khillon on 3/25/19.
//  Copyright © 2019 Sarthak Khillon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ToViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    let bag = DisposeBag()
    var filteredCurrencies = [(String, String)]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return createCurrencyCell(tableView: tableView, data: filteredCurrencies, cellId: "toCell", indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let symbol = tableView.cellForRow(at: indexPath)?.textLabel?.text else {
            fatalError("wat")
        }
        
        targetCurrencySymbol = symbol
        
        finishUp()
    }
    
    private func finishUp() {
        let message = "You wanted to convert from \(baseCurrencySymbol) to \(targetCurrencySymbol)"
        
        let alertVc = UIAlertController(title: "Done!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        alertVc.addAction(okAction)
        present(alertVc, animated: true, completion: nil)
    }
}

//
//  MainViewController.swift
//  HealthKitPractice
//
//  Created by Samantha Gatt on 8/19/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var quantityTypeTableView: UITableView!
}

// MARK: - Life Cycle
extension MainViewController {
    override func viewDidLoad() {
        HealthKitManager.authorizeHealthKit { (_, _) in }
    }
}

// MARK: - TableViewDataSource
extension MainViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HealthKitManager.hkQuantTypeIdentifiersToRead.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = HealthKitManager.hkQuantTypeIdentifiersToRead[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuantityTypeCell", for: indexPath)
        cell.textLabel?.text = identifier.rawValue
        return cell
    }
}

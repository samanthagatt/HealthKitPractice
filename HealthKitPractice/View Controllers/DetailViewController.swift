//
//  DetailViewController.swift
//  HealthKitPractice
//
//  Created by Samantha Gatt on 8/21/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit
import HealthKit

final class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    var quantityTypeId: HKQuantityTypeIdentifier? {
        didSet {
            if let id = quantityTypeId {
                guard let sampleType = HKSampleType.quantityType(forIdentifier: id) else {
                    presentErrorAlert(with: "\(id.rawValue) is no longer available in HealthKit")
                    return
                }
                HealthKitManager.getSamples(for: sampleType) { [weak self] (samples, hkError) in
                    if let error = hkError {
                        self?.presentErrorAlert(from: error)
                    }
                    guard let samples = samples else { return }
                    self?.samples = samples
                    self?.samplesTableView.reloadData()
                }
            }
        }
    }
    var samples: [HKQuantitySample] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var samplesTableView: UITableView!
}

// MARK: - Table View Data Source
extension DetailViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sample = samples[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.textLabel?.text = sample.toString(preferredUnit: quantityTypeId?.getPreferredUnits())
        return cell
    }
}

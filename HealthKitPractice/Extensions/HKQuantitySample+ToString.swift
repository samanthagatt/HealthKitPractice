//
//  HKQuantitySample+ToString.swift
//  HealthKitPractice
//
//  Created by Samantha Gatt on 8/21/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import HealthKit

extension HKQuantitySample {
    func toString(preferredUnit: HKUnit?) -> String {
        guard let preferredUnit = preferredUnit else {
            return "Sample type not supported"
        }
        let measurement = Measurement(value: quantity.doubleValue(for: preferredUnit), unit: Unit(symbol: preferredUnit.unitString))
        return HealthKitManager.measurementFormatter.string(from: measurement)
    }
}

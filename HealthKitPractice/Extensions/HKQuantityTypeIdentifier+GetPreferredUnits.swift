//
//  HKQuantityTypeIdentifier+GetPreferredUnits.swift
//  HealthKitPractice
//
//  Created by Samantha Gatt on 8/21/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import HealthKit

extension HKQuantityTypeIdentifier {
    func getPreferredUnits() -> HKUnit? {
        switch self {
        case .bodyMass:
            return .pound()
        case .bloodPressureSystolic:
            return .millimeterOfMercury()
        case .bloodPressureDiastolic:
            return .millimeterOfMercury()
        case .heartRate:
            return .init(from: "count/min")
        case .stepCount:
            return .count()
        default:
            return nil
        }
    }
}

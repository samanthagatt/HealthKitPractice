//
//  HealthKitManager.swift
//  HealthKitPractice
//
//  Created by Samantha Gatt on 8/20/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import HealthKit

enum HealthKitError: Error {
    case healthStoreNotAvailable
    case dataTypeNotAuthorized
    case authorizationError(error: Error)
}

final class HealthKitManager {
    static func authorizeHealthKit(completion: @escaping (Bool, HealthKitError?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, .healthStoreNotAvailable)
            return
        }
        guard let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let bloodPressureSystolic = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
            let bloodPressureDiastolic = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else {
                completion(false, .dataTypeNotAuthorized)
                return
        }
        let readTypes: Set<HKObjectType> = [bodyMass, bloodPressureSystolic, bloodPressureDiastolic, heartRate, HKObjectType.workoutType()]
        HKHealthStore().requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                completion(success, .authorizationError(error: error))
            } else {
                completion(success, nil)
            }
        }
    }
}

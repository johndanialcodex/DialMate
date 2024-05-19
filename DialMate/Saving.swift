//
//  Saving.swift
//  DialMate
//
//  Created by Johndanial on 5/18/24.
//
import Foundation
import SwiftUI

@propertyWrapper
struct Saving<T: Hashable>: DynamicProperty where T: Codable {
    var projectedValue: [T] = .init()
    var wrappedValue: [T] {
        get {
            return projectedValue
        }
        set {
            self.projectedValue = newValue
            DirectoryService.writeModelToDisk(projectedValue)
        }
    }
    init() {
        self.projectedValue = (try? DirectoryService.readModelFromDisk()) ?? [T]()
    }
}

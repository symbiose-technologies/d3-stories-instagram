//
//  IStory.swift
//
//
//  Created by Igor Shelopaev on 23.06.2022.
//

import SwiftUI

/// Interface defining story view
@available(iOS 15.0, macOS 12.0, tvOS 16.0, watchOS 10.0, *)
public protocol IStory: Hashable {
    associatedtype ViewTpl: View

    // MARK: - Config

    /// Optional param to define color scheme for some stories
    /// Sometimes one story demands light scheme the other demands dark because of story's design
    var colorScheme: ColorScheme? { get }

    /// Story duration
    var duration: TimeInterval { get }

    // MARK: - API

    /// Define view template for every story
    func builder(progress: Binding<CGFloat>) -> ViewTpl

    /// Check the position relatively the currently showing story
    func isBefore(_ current: Self) -> Bool

    /// Get next element
    var next: Self { get }

    /// Get previous element
    var previous: Self { get }
}


public extension IStory {
    /// Default scheme
    var colorScheme: ColorScheme? { nil }
}



extension IStory where Self: CaseIterable {
    
    
    /// Check the position relatively the currently showing story
    /// - Parameter current: Current story
    /// - Returns: true - `self`  is before current
    public func isBefore(_ current: Self) -> Bool {
        let all = Self.allCases

        guard let itemIdx = all.firstIndex(of: current) else {
            return false
        }

        guard let idx = all.firstIndex(of: self) else {
            return false
        }

        return idx < itemIdx
    }

    /// Get next element
    /// - Returns: previous element or current if previous does not exist
    public var next: Self {
        let all = Self.allCases
        let startIndex = all.startIndex
        let endIndex = all.endIndex

        guard let idx = all.firstIndex(of: self) else {
            return self
        }

        let next = all.index(idx, offsetBy: 1)

        return next == endIndex ? all[startIndex] : all[next]
    }

    /// Get previous element
    /// - Returns: previous element or current if previous does not exist
    public var previous: Self {
        let all = Self.allCases
        let startIndex = all.startIndex
        let endIndex = all.index(all.endIndex, offsetBy: -1)

        guard let idx = all.firstIndex(of: self) else {
            return self
        }

        let previous = all.index(idx, offsetBy: -1)

        return previous < startIndex ? all[endIndex] : all[previous]
    }
}

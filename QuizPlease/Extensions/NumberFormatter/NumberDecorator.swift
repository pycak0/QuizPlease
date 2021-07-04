//
//  NumberDecorator.swift
//  QuizPlease
//
//  Created by Владислав on 22.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

public protocol NumberFormatterProtocol {
    func string(from number: NSNumber) -> String?
    func number(from string: String) -> NSNumber?
}

extension NumberFormatter: NumberFormatterProtocol {}

public class NumberDecorator: NumberFormatterProtocol {
    let baseFormatter: NumberFormatterProtocol
    
    public init(baseFormatter: NumberFormatterProtocol = NumberFormatter.decimalFormatter) {
        self.baseFormatter = baseFormatter
    }
    
    public func string(from number: NSNumber) -> String? {
        baseFormatter.string(from: number)
    }
    
    public func number(from string: String) -> NSNumber? {
        baseFormatter.number(from: string)
    }
}

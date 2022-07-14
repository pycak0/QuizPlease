//
//  MultipartFormDataObject.swift
//  QuizPlease
//
//  Created by Владислав on 13.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

struct MultipartFormDataObject {
    let name: String
    let data: Data
    let fileName: String?
    let mimeType: String?

    /// This initializer will fail if `stringData`is `nil`. Made for convenience to use with `compactMap` in arrays
    /// - parameter optionalStringData: If this parameter is not `nil`,
    /// the initializer will call `init(name:stringData:fileName:mimeType:)`.
    /// Otherwise, this initializer will return `nil`.
    init?(name: String, optionalStringData: String?, fileName: String? = nil, mimeType: String? = nil) {
        guard let string = optionalStringData else { return nil }
        self.init(name: name, stringData: string, fileName: fileName, mimeType: mimeType)
    }

    /// This initializer is made just for convenience,
    /// it converts `stringData` to `Data` and calls `init(name:data:fileName:mimeType:)`
    /// - parameter stringData: Will be converted to Data using `Data(stringData.utf8)`
    init(name: String, stringData: String, fileName: String? = nil, mimeType: String? = nil) {
        self.init(name: name, data: Data(stringData.utf8), fileName: fileName, mimeType: mimeType)
    }

    init(name: String, data: Data, fileName: String? = nil, mimeType: String? = nil) {
        self.name = name
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

typealias MultipartFormDataObjects = [MultipartFormDataObject]

extension Array where Element == MultipartFormDataObject {
    /// Only non-nil values of `dictionary` are used to initialize the array.
    init(_ dictionary: [String: String?]) {
        self = dictionary.compactMap { MultipartFormDataObject(name: $0.key, optionalStringData: $0.value) }
    }
}

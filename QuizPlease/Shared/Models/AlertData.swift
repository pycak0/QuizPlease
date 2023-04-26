//
//  AlertData.swift
//  QuizPlease
//
//  Created by Владислав on 26.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Alert data model
struct AlertData: Decodable {

    /// Alert title
    let title: String
    /// Alert message
    let text: String
}

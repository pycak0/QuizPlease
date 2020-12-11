//
//  CertificateResponse.swift
//  QuizPlease
//
//  Created by Владислав on 12.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct CertificateResponse: Decodable {
    var success: Bool
    var message: String?
}

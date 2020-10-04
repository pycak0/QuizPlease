//
//  CheckInData.swift
//  QuizPlease
//
//  Created by Владислав on 03.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct CheckInData: Encodable {
    ///QR Code
    var token: String
    
    ///Team Id
    var recordId: Int? = nil
}

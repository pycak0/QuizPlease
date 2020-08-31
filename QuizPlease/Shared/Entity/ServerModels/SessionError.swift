//
//  SessionError.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case invalidUrl, jsonError, serverError(_ statusCode: Int)
    case other(Error)
}

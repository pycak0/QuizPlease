//
//  ScheduleInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ScheduleInteractorProtocol: class {
    func loadSchedule(completion: @escaping (Result<[GameInfo]?, Error>) -> Void)
}

class ScheduleInteractor: ScheduleInteractorProtocol {
    func loadSchedule(completion: @escaping (Result<[GameInfo]?, Error>) -> Void) {
        completion(.failure(NSError(domain: "loadSchedule() is not implemented", code: -1, userInfo: [:])))
    }
}

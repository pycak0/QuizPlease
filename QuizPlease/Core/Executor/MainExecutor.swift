//
//  MainExecutor.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 27.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation

final class MainExecutor: AsyncExecutor {

    func async(execute work: @escaping () -> Void) {
        DispatchQueue.main.async(execute: work)
    }
}

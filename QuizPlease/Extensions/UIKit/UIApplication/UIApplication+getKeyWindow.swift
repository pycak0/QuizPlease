//
//  UIApplication+getKeyWindow.swift
//  QuizPlease
//
//  Created by Владислав on 28.10.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .keyWindow
    }
}

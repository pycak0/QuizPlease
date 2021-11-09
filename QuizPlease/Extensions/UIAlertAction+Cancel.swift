//
//  UIAlertAction+Cancel.swift
//  QuizPlease
//
//  Created by Владислав on 07.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    /// Creates a new instance with `title: "Отмена", style: .cancel, handler: nil`
    static var cancel: UIAlertAction {
        UIAlertAction(title: "Отмена", style: .cancel)
    }
}

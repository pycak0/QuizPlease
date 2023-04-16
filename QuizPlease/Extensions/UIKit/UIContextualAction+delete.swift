//
//  UIContextualAction+delete.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

extension UIContextualAction {

    static func delete(handler: (() -> Void)? = nil) -> UIContextualAction {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { _, _, completion in
                handler?()
                completion(true)
            }
        )
        deleteAction.backgroundColor = .systemGray5Adapted
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash.circle.fill")
        } else {
            deleteAction.title = "Удалить"
        }
        return deleteAction
    }
}

//
//  WarmupRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol WarmupRouterProtocol: Router {

    func showShareSheet(with items: [Any])

    func showShareSheet(with image: UIImage)
}

class WarmupRouter: WarmupRouterProtocol {

    unowned let viewController: UIViewController
    private let shareSheet: ShareSheetProtocol

    required init(
        viewController: UIViewController,
        shareSheet: ShareSheetProtocol
    ) {
        self.viewController = viewController
        self.shareSheet = shareSheet
    }

    func showShareSheet(with items: [Any]) {
        shareSheet.present(on: viewController, with: items, completion: { _ in })
    }

    func showShareSheet(with image: UIImage) {
        shareSheet.present(on: viewController, with: image, completion: { _ in })
    }
}

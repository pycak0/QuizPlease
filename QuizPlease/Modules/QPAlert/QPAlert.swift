//
//  QPAlert.swift
//  QuizPlease
//
//  Created by Владислав on 27.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// QuizPlease Alert
final class QPAlert {

    weak var view: QPAlertViewController?

    private let title: String
    private var buttons: [QPAlertButtonModel] = []

    init(title: String) {
        self.title = title
    }

    func withPrimaryButton(title: String, action: (() -> Void)?) -> QPAlert {
        buttons.append(QPAlertButtonModel(title: title, style: .primary, tapAction: action))
        return self
    }

    func withBasicButton(title: String, action: (() -> Void)?) -> QPAlert {
        buttons.append(QPAlertButtonModel(title: title, style: .basic, tapAction: action))
        return self
    }

    func show() {
        let view = QPAlertViewController(title: title)
        view.setButtons(buttons)

        // TODO: refactor with transitioning delegate
        // to be able to use native `present(_:animated:completion:)`
        // and get rid of custom `show()`
        //  https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html
        UIApplication.shared
            .getKeyWindow()?
            .topViewController?
            .present(view, animated: false) { [view] in
                view.show()
            }

        self.view = view
    }

    func hide() {
        view?.hide()
    }
}

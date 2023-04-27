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

    /// You may add only one primary button.
    /// If you call this methd multiple times, only the last primary button will be presented
    func addPrimaryButton(title: String, action: (() -> Void)?) {
        buttons.removeAll(where: { $0.style == .primary })
        buttons.append(QPAlertButtonModel(title: title, style: .primary, tapAction: action))
    }

    /// You may add only one primary button.
    /// If you call this methd multiple times, only the last primary button will be presented
    func withPrimaryButton(title: String, action: (() -> Void)?) -> QPAlert {
        addPrimaryButton(title: title, action: action)
        return self
    }

    func addBasicButton(title: String, action: (() -> Void)?) {
        buttons.append(QPAlertButtonModel(title: title, style: .basic, tapAction: action))
    }

    func withBasicButton(title: String, action: (() -> Void)?) -> QPAlert {
        addBasicButton(title: title, action: action)
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

    func hide(completion: (() -> Void)? = nil) {
        view?.hide(completion: completion)
    }
}

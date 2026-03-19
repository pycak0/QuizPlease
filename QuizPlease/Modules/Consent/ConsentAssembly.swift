//
//  ConsentAssembly.swift
//  QuizPlease
//
//  Created on 14.03.2026.
//

import UIKit

/// Assembly for the Consent screen presented as a sheet
final class ConsentAssembly {

    /// Create a consent view controller configured for sheet presentation
    /// - Parameter onAccepted: Callback invoked when the user accepts the consent
    func makeViewController(onAccepted: @escaping () -> Void) -> UIViewController {
        let consentVC = ConsentViewController()
        consentVC.onConsentAccepted = { [weak consentVC] in
            consentVC?.dismiss(animated: true) {
                onAccepted()
            }
        }

        if let sheet = consentVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { context in
                        context.maximumDetentValue * 0.85
                    }
                ]
            } else {
                sheet.detents = [.large()]
            }
            sheet.prefersGrabberVisible = false
            sheet.prefersEdgeAttachedInCompactHeight = true
        }

        return consentVC
    }
}

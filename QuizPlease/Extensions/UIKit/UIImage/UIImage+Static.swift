//
//  UIImage+Static.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIImage {

    /// The colored app logo image (`logoSmall`), rendered in original colors.
    class var logoColoredImage: UIImage? {
        UIImage(named: "logoSmall")?.withRenderingMode(.alwaysOriginal)
    }

    /// The template app logo image (`logoSmall`), rendered as a template for tinting.
    class var logoTemplateImage: UIImage? {
        UIImage(named: "logoSmall")?.withRenderingMode(.alwaysTemplate)
    }

    /// The background image for the logo screen (`launchScreenBackground`).
    class var logoScreenBackground: UIImage? {
        UIImage(named: "launchScreenBackground")
    }

    /// The back button image (`backButton`), always rendered as a template.
    class var backButton: UIImage {
        UIImage(named: "backButton")!.withRenderingMode(.alwaysTemplate)
    }

    /// The standard system "xmark" (close) symbol image.
    class var xmark: UIImage? {
        UIImage(systemName: "xmark")
    }

    /// The standard system "plus" (add) symbol image.
    class var plus: UIImage? {
        UIImage(systemName: "plus")
    }

    /// The standard system "minus" (remove) symbol image.
    class var minus: UIImage? {
        UIImage(systemName: "minus")
    }

    /// The standard system "location" symbol image.
    class var location: UIImage? {
        UIImage(systemName: "location")
    }

    /// The custom down arrow image (`arrowDown`).
    class var arrowDown: UIImage? {
        return UIImage(named: "arrowDown")
    }

    /// The filter image (`filter`), rendered in original colors.
    class var filter: UIImage? {
        UIImage(named: "filter")?.withRenderingMode(.alwaysOriginal)
    }

    /// Image with 3 dots to use in menus
    class var menuOptions: UIImage? {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .large)
        return UIImage(systemName: "ellipsis", withConfiguration: symbolConfig)
    }
}

//
//  UIImage+Static.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIImage {
    class var logoColoredImage: UIImage? {
        UIImage(named: "logoSmall")?.withRenderingMode(.alwaysOriginal)
    }

    class var logoTemplateImage: UIImage? {
        UIImage(named: "logoSmall")?.withRenderingMode(.alwaysTemplate)
    }

    class var logoScreenBackground: UIImage? {
        UIImage(named: "launchScreenBackground")
    }

    class var backButton: UIImage {
        UIImage(imageLiteralResourceName: "backButton")
    }

    class var xmark: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "xmark")
        }
        return UIImage(named: "xmarkIcon")
    }

    class var plus: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "plus")
        }
        return UIImage(named: "plus")
    }

    class var minus: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "minus")
        }
        return UIImage(named: "minus")
    }

    class var location: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "location")
        }
        return UIImage(named: "compass")
    }

    class var arrowDown: UIImage? {
        return UIImage(named: "arrowDown")
    }
}

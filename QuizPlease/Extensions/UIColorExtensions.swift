//
//  UIColorExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 18.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Colors
public extension UIColor {
    class var darkBlue: UIColor {
        return UIColor(named: "darkBlue")!
    }
    
    ///In the light appearance, it's the same color as `darkBlue` but in the dark appearance it becomes white.
    class var darkBlueDynamic: UIColor {
        UIColor(named: "darkBlueDynamic")!
    }
    
    class var middleBlue: UIColor {
        UIColor(named: "middleBlue")!
    }
    
    ///dark blue with kind of purple
    class var plum: UIColor {
        UIColor(named: "plum")!
    }
    
    class var olive: UIColor {
        return UIColor(named: "olive")!
    }
    
    class var lemon: UIColor {
        return UIColor(named: "lemon")!
    }
    
    class var lightOrange: UIColor {
        return UIColor(named: "lightOrange")!
    }
    
    class var lightGreen: UIColor {
        return UIColor(named: "lightGreen")!
    }
    
    class var themeGray: UIColor {
        UIColor(named: "themeGray")!
    }
    
    class var turquoise: UIColor {
        UIColor(named: "turquoise")!
    }
    
    class var bluishGreen: UIColor {
        UIColor(named: "bluishGreen")!
    }
    
    class var roseRed: UIColor {
        UIColor(named: "roseRed")!
    }
    
    class var citySky: UIColor {
        UIColor(named: "citySky")!
    }
    
    class var skyAzure: UIColor {
        UIColor(named: "skyAzure")!
    }
    
    class var labelAdapted: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        }
        return .black
    }
    
    class var systemBackgroundAdapted: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        }
        return .white
    }

}


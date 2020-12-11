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
}

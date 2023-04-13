//
//  UIStoryboard+Main.swift
//  QuizPlease
//
//  Created by Владислав on 24.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

extension UIStoryboard {

    /// Returns storybard got from `Main.storyboard` file
    class var main: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
}

//
//  UIImageView+LoadImage.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL?, placeholderImage: UIImage? = nil, handler: ((UIImage?) -> Void)? = nil) {
        guard let url = url else {
            return
        }
        if placeholderImage != nil {
            image = placeholderImage
        }
//
//        return PixabaySearch.shared.getImage(with: url) { (image) in
//            self.image = image
//            handler?(image)
//        }
    }
}

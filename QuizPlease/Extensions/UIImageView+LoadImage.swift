//
//  UIImageView+LoadImage.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(url: URL?, placeholderImage: UIImage? = nil, handler: ((UIImage?) -> Void)? = nil) {
//        guard let url = url else {
//            if let img = placeholderImage {
//                self.image = img
//            }
//            return
//        }
        self.kf.setImage(with: url, placeholder: placeholderImage)
        
    }
    
    func loadImage(path: String?, placeholderImage: UIImage? = nil, handler: ((UIImage?) -> Void)? = nil) {
        var url: URL?
        if let path = path {
            var urlComponents = Globals.baseUrl
            urlComponents.path = path
            url = urlComponents.url
        }
        
        loadImage(url: url, placeholderImage: placeholderImage, handler: handler)
    }
    
    func loadImageFromMainDomain(path: String?, placeholderImage: UIImage? = nil, handler: ((UIImage?) -> Void)? = nil) {
        var url: URL?
        if let path = path {
            var urlComponents = URLComponents(string: Globals.mainDomain)!
            urlComponents.path = path
            url = urlComponents.url
        }
        
        loadImage(url: url, placeholderImage: placeholderImage, handler: handler)
    }
}

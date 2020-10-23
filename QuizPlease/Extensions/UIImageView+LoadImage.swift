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
        guard let url = url else {
            return
        }
        self.kf.setImage(with: url, placeholder: placeholderImage)
        
    }
    
    func loadImage(path: String?, placeholderImage: UIImage? = nil, handler: ((UIImage?) -> Void)? = nil) {
        guard let path = path else { return }
        var urlComponents = Globals.baseUrl
        urlComponents.path = path
        
        loadImage(url: urlComponents.url, placeholderImage: placeholderImage, handler: handler)
    }
    
    func loadImageFromMainDomain(path: String?, placeholderImage: UIImage? = nil, handler: ((UIImage?) -> Void)? = nil) {
        guard let path = path else { return }
        var urlComponents = URLComponents(string: Globals.mainDomain)!
        urlComponents.path = path
        
        loadImage(url: urlComponents.url, placeholderImage: placeholderImage, handler: handler)
    }
}

extension UIImage {
    class var logoColoredImage: UIImage? {
        UIImage(named: "logoSmall")?.withRenderingMode(.alwaysOriginal)
    }
}

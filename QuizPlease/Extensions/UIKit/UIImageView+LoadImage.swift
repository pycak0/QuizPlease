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
        self.kf.setImage(with: url, placeholder: placeholderImage, completionHandler: { result in
            switch result {
            case let .failure(error):
                print(error)
                handler?(nil)
            case let .success(imageResult):
                handler?(imageResult.image)
            }
        })
    }

    func loadImage(
        using configuration: NetworkConfiguration = .standard,
        path: String?,
        placeholderImage: UIImage? = nil,
        handler: ((UIImage?) -> Void)? = nil
    ) {
        var url: URL?
        if let path = path, var urlComponents = URLComponents(string: configuration.host) {
            urlComponents.path = path
            url = urlComponents.url
        }
        loadImage(url: url, placeholderImage: placeholderImage, handler: handler)
    }
}

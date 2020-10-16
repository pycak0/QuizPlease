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
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data,
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    handler?(image)
                }
            } else {
                DispatchQueue.main.async {
                    handler?(nil)
                }
            }
        }.resume()
        
    }
}

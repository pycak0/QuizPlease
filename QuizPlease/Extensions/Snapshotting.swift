//
//  Snapshotting.swift
//  QuizPlease
//
//  Created by Владислав on 04.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol Snapshotable {
    func makeSnapshot() -> UIImage?
}

extension UIApplication: Snapshotable {
    func makeSnapshot() -> UIImage? {
        getKeyWindow()?.makeSnapshot()
    }
}

extension CALayer: Snapshotable {
    func makeSnapshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { ctx in
            render(in: ctx.cgContext)
        }
    }
}

extension UIView: Snapshotable {
    func makeSnapshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}

extension UIImage {
    convenience init?(snapshotOf view: UIView) {
        guard let image = view.makeSnapshot(), let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

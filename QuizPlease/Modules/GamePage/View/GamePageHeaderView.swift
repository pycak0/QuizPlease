//
//  GamePageHeaderView.swift
//  QuizPlease
//
//  Created by Владислав on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage header view containing an image
final class GamePageHeaderView: UIView {

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameInfoTemplate")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageDimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Loads the image with given path and sets to the header view
    /// - Parameter path: image location on a server
    func setImage(path: String) {
//        loadImage(path: path) { [weak self] image in
//            if image == nil && Configuration.current != .production {
//                // When running on a staging server, image may not be located there,
//                // so try to force-load it from the production
//                self?.loadImage(path: path, configuration: .production)
//            }
//        }
    }

    // MARK: - Private Methods

    private func loadImage(
        path: String,
        configuration: NetworkConfiguration = .standard,
        completion: ((UIImage?) -> Void)? = nil
    ) {
        let placeholder = UIImage(named: "gameInfoTemplate")
        imageView.loadImage(
            using: configuration,
            path: path,
            placeholderImage: placeholder,
            handler: completion
        )
    }

    private func configure() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        addSubview(imageDimmingView)
        NSLayoutConstraint.activate([
            imageDimmingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageDimmingView.topAnchor.constraint(equalTo: self.topAnchor),
            imageDimmingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageDimmingView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

//
//  ShareSheet.swift
//  QuizPlease
//
//  Created by Владислав on 04.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import LinkPresentation

protocol ShareSheetProtocol {

    func present(on viewController: UIViewController, with items: [Any], completion: @escaping (Bool) -> Void)

    func present(on viewController: UIViewController, with image: UIImage, completion: @escaping (Bool) -> Void)

    func present(on viewController: UIViewController, with url: URL, completion: @escaping (Bool) -> Void)
}

class ShareSheet: NSObject, ShareSheetProtocol {

    var tempImage: UIImage?

    // MARK: - ShareSheetProtocol

    /// Present Share Sheet with any supported items
    ///
    /// This method should be used for sharing multiple different items at once.
    /// If you have a single image or a URL to share,
    /// prefer to use special methods for this to achieve better UX.
    func present(
        on viewController: UIViewController,
        with items: [Any],
        completion: @escaping (Bool) -> Void
    ) {
        let shareSheetVc = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        shareSheetVc.popoverPresentationController?.sourceView = viewController.view
        shareSheetVc.completionWithItemsHandler = { _, completed, _, _ in
            completion(completed)
        }
        viewController.present(shareSheetVc, animated: true)
    }

    /// Present Share Sheet with an image
    ///
    /// This method is designed not only for convenience
    /// but also for correct image preview in Share Sheet.
    /// (When using universal method with '`items`' parameter,
    /// you'll not able to see the preview of `UIImage` instance passed to that method)
    func present(
        on viewController: UIViewController,
        with image: UIImage,
        completion: @escaping (Bool) -> Void
    ) {
        tempImage = image
        present(on: viewController, with: [image, self], completion: completion)
    }

    /// Present Share Sheet with a URL
    func present(
        on viewController: UIViewController,
        with url: URL,
        completion: @escaping (Bool) -> Void
    ) {
        present(on: viewController, with: [url], completion: completion)
    }
}

// MARK: - UIActivityItemSource

extension ShareSheet: UIActivityItemSource {

    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        ""
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        nil
    }

    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {
        defer { tempImage = nil }
        guard let image = tempImage else {
            return nil
        }
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.title = "Разминка в Квиз, плиз!"
        metadata.imageProvider = imageProvider
        return metadata
    }
}

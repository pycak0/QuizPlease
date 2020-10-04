//
//  ShareManager.swift
//  QuizPlease
//
//  Created by Владислав on 04.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ShareManager {
    //singleton
    private init() {}
    
    //MARK:- Share Image
    static func presentShareSheet(for image: UIImage?, delegate: UIViewController, title: String? = nil) {
        guard let image = image else {
            delegate.showSimpleAlert(title: "Не удалось поделиться фото", message: "Пожалуйста, попробуйте повторить позже")
            return
        }
        
        let shareSheetVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = delegate.view
        shareSheetVC.title = title ?? "Фото"
        
        delegate.present(shareSheetVC, animated: true, completion: nil)
    }
    
    //MARK:- Share URL
    static func presentShareSheet(for url: URL?, delegate: UIViewController, title: String? = nil) {
        guard let url = url else {
            print("Invalid url passed to the ShareManager")
            return
        }
        
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = delegate.view
        
        delegate.present(shareSheetVC, animated: true, completion: nil)
    }
}

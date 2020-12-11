//
//  CameraChecker.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import AVKit

class CameraChecker {
    private init() {}
    
    //MARK:- Check Camera Access
    /**
     - Parameters:
         - vc: View Controller where alerts will be presented;
         - completion: action to do if access is granted
    **/
    static func checkCameraAccess(vc: UIViewController, grantedCompletion: @escaping (() -> Void),
                                  deniedAlertOkButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            grantedCompletion()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        grantedCompletion()
                    } else {
                        //
                    }
                }
            }
        default:
            let alert = UIAlertController(title: "Нет доступа к камере для сканирования QR", message: "Разрешить доступ к Камере можно в \"Настройках\"", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "ОК", style: .default, handler: deniedAlertOkButtonHandler)
            let settingsBtn = UIAlertAction(title: "Настройки", style: .cancel) { (action) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(okBtn)
            alert.addAction(settingsBtn)
            //alert.view.tintColor = .labelAdapted
            vc.present(alert, animated: true)
        }
    }
}

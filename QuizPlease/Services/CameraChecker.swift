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

    /**
     - Parameters:
         - presentationController: View Controller where alerts will be presented
         - completion: action to do if access is granted
    */
    static func checkCameraAccess(
        presentationController: UIViewController,
        completion: @escaping (_ isGranted: Bool) -> Void
    ) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
                DispatchQueue.main.async {
                    completion(isGranted)
                }
            }
        default:
            let alert = UIAlertController(
                title: "Нет доступа к камере для сканирования QR",
                message: "Разрешить доступ к Камере можно в \"Настройках\"",
                preferredStyle: .alert
            )
            let okBtn = UIAlertAction(title: "ОК", style: .default) { _ in
                completion(false)
            }
            let settingsBtn = UIAlertAction(title: "Настройки", style: .cancel) { (_) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(okBtn)
            alert.addAction(settingsBtn)
            // alert.view.tintColor = .labelAdapted
            presentationController.present(alert, animated: true)
        }
    }
}

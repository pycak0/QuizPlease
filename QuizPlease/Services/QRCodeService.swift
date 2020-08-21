//
//  QRCodeService.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeService {
    
    enum CaptureSessionError: Error {
        case notSupported, other(Error)
        
        var localizedDescription: String {
            switch self {
            case .notSupported:
                return "Ваше устройство не поддерживает сканирование QR-кодов"
            case let .other(error):
                return error.localizedDescription
            }
        }
    }
    
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
    
    
    //MARK:- Capture Session Configuration
    static func getCaptureSessionConfiguration(_ delegate: AVCaptureMetadataOutputObjectsDelegate?,
                                                  previewLayerFrame: CGRect,
                                                  handler: (_ captureSession: AVCaptureSession?, _ previewLayer: AVCaptureVideoPreviewLayer?, _ error: CaptureSessionError?) -> Void) {
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            handler(nil, nil, .notSupported)
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            handler(nil, nil, .notSupported)
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = previewLayerFrame
        previewLayer.videoGravity = .resizeAspectFill
        
        handler(captureSession, previewLayer, nil)
        
    }
}

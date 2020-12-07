//
//MARK:  QRCodeService.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVFoundation

//MARK:- Delegate Protocol
protocol QRCodeServiceResultsDelegate: class {
    ///When the '`result`' is non-`nil`, `QRCodeService` is guaranteed to stop scan session
    func didFinishCodeScanning(with result: String?)
    
    func didFailToSetupCaptureSession(with error: QRCodeService.CaptureSessionError)
}

class QRCodeService: NSObject {
    
    //MARK:- Session Error
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
    
    static let shared = QRCodeService()
    
    private weak var delegate: QRCodeServiceResultsDelegate?
    private var captureSession: AVCaptureSession?
    
    //MARK:- Setup QR Scanner
    ///This method is much easier in use than the `setupCaptureSessionConfiguration`
    func setupQrScanner(in view: UIView, resultsDelegate: QRCodeServiceResultsDelegate) {
        delegate = resultsDelegate
        setupCaptureSessionConfiguration(self, previewLayerFrame: view.bounds) { (captureSession, previewLayer, error) in
            if let error = error {
                resultsDelegate.didFailToSetupCaptureSession(with: error)
                return
            }
            self.captureSession = captureSession
            view.layer.insertSublayer(previewLayer!, at: 0)
            captureSession?.startRunning()
        }
    }
    
    
    //MARK:- Capture Session Configuration
    @available(*, deprecated, message: "use setupQrScanner(in:resultsDelegate:) instead")
    func setupCaptureSessionConfiguration(_ delegate: AVCaptureMetadataOutputObjectsDelegate?,
                                          previewLayerFrame: CGRect,
                                          handler: (_ captureSession: AVCaptureSession?, _ previewLayer: AVCaptureVideoPreviewLayer?, _ error: CaptureSessionError?) -> Void)
    {
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
        else {
            handler(nil, nil, .notSupported)
            return
        }
        
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            handler(nil, nil, .notSupported)
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

//MARK:- AVCaptureMetadataOutputObjectsDelegate
extension QRCodeService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
        else {
            delegate?.didFinishCodeScanning(with: nil)
            return
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        captureSession?.stopRunning()
        delegate?.didFinishCodeScanning(with: stringValue)
        
    }
}

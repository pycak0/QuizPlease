//
//MARK:  QRCodeService.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCodeServiceProtocol {
    var isFlashEnabled: Bool { get set }
    
    ///- parameter delegate: Must be an `unonwed let` property
    init(delegate: QRCodeServiceResultsDelegate)
    
    ///This method creates a camera preview layer and configures capture session for scanning QR codes
    ///
    ///Call can throw if the device does not have a camera
    func makePreviewLayer(frame: CGRect) throws -> CALayer
    
    func startCaptureSession()
    func stopCaptureSession()
}

// MARK: - Delegate Protocol
protocol QRCodeServiceResultsDelegate: AnyObject {
    ///When the '`result`' parameter is non-`nil`, `QRCodeService` is guaranteed to stop scan session
    func didFinishCodeScanning(with result: String?)
}

class QRCodeService: NSObject, QRCodeServiceProtocol {
    
    // MARK: - Session Error
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
        
    private var captureSession: AVCaptureSession?
    private var captureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    
    unowned let delegate: QRCodeServiceResultsDelegate

    // MARK: - Camera Flash
    var isFlashEnabled = false {
        didSet {
            guard captureDevice?.isTorchAvailable ?? false else { return }
            do {
                try captureDevice?.lockForConfiguration()
                captureDevice?.torchMode = isFlashEnabled ? .on : .off
            } catch {
                print(error)
            }
        }
    }
    
    required init(delegate: QRCodeServiceResultsDelegate) {
        self.delegate = delegate
    }
    
    ///To start scanning QR codes, you should call this method
    func startCaptureSession() {
        captureSession?.startRunning()
    }

    ///Capture Session automatically stops and calls delegate method when found something, but you can explicitly stop capture session if needed
    func stopCaptureSession() {
        if let session = captureSession, session.isRunning {
            session.stopRunning()
        }
    }
    
    // MARK: - Setup QR Scanner
    ///This method typically throws if the device does not have a camera
    func makePreviewLayer(frame: CGRect) throws -> CALayer {
        try setupCaptureSessionConfiguration(
            metadataOutputDelegate: self,
            previewLayerFrame: frame
        )
    }
    
    // MARK: - Capture Session Configuration
    ///This method can throw if
    private func setupCaptureSessionConfiguration(
        metadataOutputDelegate delegate: AVCaptureMetadataOutputObjectsDelegate,
        previewLayerFrame: CGRect
    ) throws -> AVCaptureVideoPreviewLayer {
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = captureDevice else {
            throw CaptureSessionError.notSupported
        }
        
        let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            throw CaptureSessionError.notSupported
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            throw CaptureSessionError.notSupported
        }
        
        self.captureSession = captureSession

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = previewLayerFrame
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
        else {
            delegate.didFinishCodeScanning(with: nil)
            return
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        captureSession?.stopRunning()
        delegate.didFinishCodeScanning(with: stringValue)
    }
}

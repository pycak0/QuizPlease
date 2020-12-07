//
//  QRScannerVC.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVFoundation

//MARK:- Delegate Protocol
protocol QRScannerVCDelegate: class {
    func qrScanner(_ qrScanner: QRScannerVC, didFinishCodeScanningWith result: String?)
}

class QRScannerVC: UIViewController {
    
    weak var delegate: QRScannerVCDelegate?

    var captureSession: AVCaptureSession?
    var captureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    
    //MARK:- Camera Flash
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    private func checkCamera() {
        CameraChecker.checkCameraAccess(
            vc: self,
            grantedCompletion: {
                self.configure()
        },
            deniedAlertOkButtonHandler: { _ in
                self.dismiss(animated: true, completion: nil)
        })
    }
    
    //MARK:- Configure
    private func configure() {
        QRCodeService.shared.setupCaptureSessionConfiguration(self, previewLayerFrame: view.bounds) { (captureSession, previewLayer, error) in
            if let error = error {
                self.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            self.captureSession = captureSession
            self.view.layer.insertSublayer(previewLayer!, at: 0)
        }
        
        captureSession?.startRunning()
    }
    
    //MARK:- Flash Button
    @IBAction func flashButtonPressed(_ sender: UIButton) {
        isFlashEnabled.toggle()
        sender.backgroundColor = isFlashEnabled ? .lemon : .systemBlue
        sender.tintColor = isFlashEnabled ? .black : .white
    }
    
    //MARK:- Close Button
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func processResult(_ code: String?) {
        //if ok
        captureSession?.stopRunning()
        delegate?.qrScanner(self, didFinishCodeScanningWith: code)
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK:- AVCaptureMetadataOutputObjectsDelegate
extension QRScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
        else {
            self.processResult(nil)
            return
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        processResult(stringValue)
    }
}

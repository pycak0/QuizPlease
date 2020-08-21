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
    
    var isFlashEnabled = false
    var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    private func checkCamera() {
        QRCodeService.checkCameraAccess(
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
        QRCodeService.getCaptureSessionConfiguration(self, previewLayerFrame: view.bounds) { (captureSession, previewLayer, error) in
            if let error = error {
                self.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            self.captureSession = captureSession
            self.view.layer.addSublayer(previewLayer!)
        }
        captureSession?.startRunning()
    }
    
    @IBAction func flahButtonPressed(_ sender: Any) {
        isFlashEnabled.toggle()
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
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
            delegate?.qrScanner(self, didFinishCodeScanningWith: nil)
            return
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //Check format first
        delegate?.qrScanner(self, didFinishCodeScanningWith: stringValue)
    }
}

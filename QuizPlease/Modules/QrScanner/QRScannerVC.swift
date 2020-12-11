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
        QRCodeService.shared.stopCaptureSession()
    }
    
    private func checkCamera() {
        CameraChecker.checkCameraAccess(
            vc: self,
            grantedCompletion: {
                self.setupScanner()
        },
            deniedAlertOkButtonHandler: { _ in
                self.dismiss(animated: true, completion: nil)
        })
    }
    
    //MARK:- Configure
    private func setupScanner() {
        QRCodeService.shared.setupQrScanner(in: view, resultsDelegate: self)
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
    
}

//MARK:- QRCodeService Results Delegate
extension QRScannerVC: QRCodeServiceResultsDelegate {
    func didFinishCodeScanning(with result: String?) {
        delegate?.qrScanner(self, didFinishCodeScanningWith: result)
        dismiss(animated: true, completion: nil)
    }
    
    func didFailToSetupCaptureSession(with error: QRCodeService.CaptureSessionError) {
        self.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription) { action in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

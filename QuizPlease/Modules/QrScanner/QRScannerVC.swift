//
//  QRScannerVC.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Delegate Protocol
protocol QRScannerVCDelegate: AnyObject {
    func qrScanner(_ qrScanner: QRScannerVC, didFinishCodeScanningWith result: String?)
}

class QRScannerVC: UIViewController {
    lazy var qrService: QRCodeServiceProtocol = QRCodeService(delegate: self)

    weak var delegate: QRScannerVCDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScanner()
        checkCamera()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrService.stopCaptureSession()
    }

    private func configureScanner() {
        do {
            let previewLayer = try qrService.makePreviewLayer(frame: view.bounds)
            view.layer.insertSublayer(previewLayer, at: 0)
        } catch {
            let error = (error as? QRCodeService.CaptureSessionError)
                ?? QRCodeService.CaptureSessionError.other(error)
            switch error {
            case .notSupported:
                handleCaptureSessionError(error)
            default:
                print(error)
            }
        }
    }

    private func checkCamera() {
        CameraChecker.checkCameraAccess(presentationController: self) { isGranted in
            if isGranted {
                DispatchQueue.global().async { self.qrService.startCaptureSession() }
            } else {
                self.dismiss(animated: true)
            }
        }
    }

    private func handleCaptureSessionError(_ error: QRCodeService.CaptureSessionError) {
        self.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Buttons
    @IBAction private func flashButtonPressed(_ sender: UIButton) {
        qrService.isFlashEnabled.toggle()
        sender.backgroundColor = qrService.isFlashEnabled ? .lemon : .systemBlue
        sender.tintColor = qrService.isFlashEnabled ? .black : .white
    }

    @IBAction private func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - QRCodeService Results Delegate
extension QRScannerVC: QRCodeServiceResultsDelegate {
    func didFinishCodeScanning(with result: String?) {
        delegate?.qrScanner(self, didFinishCodeScanningWith: result)
        dismiss(animated: true, completion: nil)
    }
}

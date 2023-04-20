//
//  ProfileRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - Router Protocol
protocol ProfileRouterProtocol: SegueRouter {
    func showShop(with userInfo: UserInfo?)
    func showQRScanner()
    func showAddGameScreen(_ info: String)

    func showAuthScreen()
    func closeProfile()
    func showOnboarding(delegate: OnboardingScreenDelegate?)
}

class ProfileRouter: ProfileRouterProtocol {

    unowned let viewController: UIViewController
    private let onboardingAssembly: OnboardingAssembly

    required init(
        viewController: UIViewController,
        onboardingAssembly: OnboardingAssembly
    ) {
        self.viewController = viewController
        self.onboardingAssembly = onboardingAssembly
    }

    // MARK: - Prepare for Segue
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowQRScreenProfile":
            guard let vc = segue.destination as? QRScannerVC else { return }
            vc.delegate = viewController as? QRScannerVCDelegate

        case "AddGameProfile":
            guard let vc = segue.destination as? AddGameVC, let info = sender as? String else {
                fatalError("Incorrect Data Passed when showing AddGameVC from Profile")
            }
            vc.token = info
            vc.delegate = viewController as? AddGameVCDelegate

        case "ShowShop":
            guard let vc = segue.destination as? ShopVC
            else { fatalError("Incorrect Data Passed when showing ShopVC from Profile Router") }

            let userInfo = sender as? UserInfo
            ShopConfigurator().configure(vc, userInfo: userInfo)

        default:
            print("no preparations made for segue with id '\(String(describing: segue.identifier))' (from ProfileVC)")
        }
    }

    // MARK: - Segues
    func showShop(with userInfo: UserInfo?) {
        viewController.performSegue(withIdentifier: "ShowShop", sender: userInfo)
    }

    func showQRScanner() {
        viewController.performSegue(withIdentifier: "ShowQRScreenProfile", sender: nil)
    }

    func showAddGameScreen(_ info: String) {
        viewController.performSegue(withIdentifier: "AddGameProfile", sender: info)
    }

    func showAuthScreen() {
        guard let authViewController = UIStoryboard.main
            .instantiateViewController(withIdentifier: "\(AuthVC.self)") as? AuthVC
        else {
            fatalError("Incorrect Data Passed when showing AuthVC from Profile Router")
        }

        authViewController.delegate = self
        let navigationController = QPNavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }

    func showOnboarding(delegate: OnboardingScreenDelegate?) {
        let onboardingViewController = onboardingAssembly.makeViewController(delegate: delegate)
        viewController.present(onboardingViewController, animated: true)
    }

    func closeProfile() {
        viewController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Auth VC Delegate
extension ProfileRouter: AuthVCDelegate {
    func didSuccessfullyAuthenticate(in authVC: AuthVC) {
        (viewController as? ProfileViewProtocol)?.presenter.didPerformAuth()
        authVC.dismiss(animated: true)
    }

    func didCancelAuth(in authVC: AuthVC) {
        authVC.dismiss(animated: true) { [unowned self] in
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}

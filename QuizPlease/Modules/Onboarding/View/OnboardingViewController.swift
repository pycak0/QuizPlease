//
//  OnboardingViewController.swift
//  QuizPlease
//
//  Created by Владислав on 12.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

enum OnboardingViewMode {

    /// Basic mode for all pages
    case basic

    /// Special mode for the last page of onboarding
    case lastPage
}

/// Onboarding View output protocol
protocol OnboardingViewOutput: AnyObject {

    /// OnboardingView was loaded into memory
    func viewDidLoad()

    /// Skip button was pressed
    func skipButtonPressed()

    /// Done button was pressed
    func doneButtonPressed()
}

/// Onboarding View input protocol
protocol OnboardingViewProtocol: AnyObject {

    /// Set onboarding pages
    func set(pages: [OnboardingPageViewModel])
}

final class OnboardingViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Private Properties

    private let output: OnboardingViewOutput

    private var viewMode: OnboardingViewMode = .basic {
        didSet {
            if oldValue != viewMode {
                resetConfiguration()
            }
        }
    }

    // MARK: UI Elements

    private lazy var onboardingView: OnboardingView = {
        let onboardingView = OnboardingView(pageSpacing: 8)
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        onboardingView.isPageControlEnabled = false
        onboardingView.delegate = self
        return onboardingView
    }()

    private lazy var nextButton: BigButton = {
        let button = BigButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()

    private lazy var skipButton: ScalingButton = {
        let button = ScalingButton()
        button.titleLabel?.font = .gilroy(.bold, size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    // MARK: - Lifecycle

    init(output: OnboardingViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .plum
        makeLayout()
        resetConfiguration()
        output.viewDidLoad()
    }

    // MARK: - Private Methods

    private func makeLayout() {
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .vertical
        hStack.spacing = 32
        [
            onboardingView,
            makeButtonsStack()
        ].forEach {
            hStack.addArrangedSubview($0)
        }
        view.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8)
        ])
    }

    private func makeButtonsStack() -> UIView {
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        [
            nextButton,
            skipButton
        ].forEach(buttonStack.addArrangedSubview(_:))

        return buttonStack
    }

    @objc
    private func skipButtonPressed() {
        output.skipButtonPressed()
    }

    @objc
    private func nextButtonPressed() {
        switch viewMode {
        case .basic:
            let nextPageIndex = onboardingView.selectedPageIndex + 1
            if nextPageIndex == onboardingView.items.count - 1 {
                viewMode = .lastPage
            }
            onboardingView.showNextPage()
        case .lastPage:
            output.doneButtonPressed()
        }
    }

    private func resetConfiguration() {
        switch viewMode {
        case .basic:
            configureForBasicMode()
        case .lastPage:
            configureForLastPageMode()
        }
    }

    private func configureForBasicMode() {
        nextButton.tintColor = .white
        nextButton.backgroundColor = .clear
        nextButton.setTitle("Дальше", for: .normal)
        skipButton.setTitle("Пропустить", for: .normal)
    }

    private func configureForLastPageMode() {
        nextButton.tintColor = .black
        nextButton.backgroundColor = .white
        nextButton.setTitle("Все понятно", for: .normal)
        skipButton.setTitle(nil, for: .normal)
    }
}

// MARK: - OnboardingViewProtocol

extension OnboardingViewController: OnboardingViewProtocol {

    func set(pages: [OnboardingPageViewModel]) {
        DispatchQueue.main.async { [self] in
            onboardingView.items = pages
        }
    }
}

// MARK: - OnboardingViewDelegate

extension OnboardingViewController: OnboardingViewDelegate {

    func didSelectPage(at pageIndex: Int) {
        if pageIndex == onboardingView.items.count - 1 {
            viewMode = .lastPage
        } else {
            viewMode = .basic
        }
    }
}

//
//  WelcomeViewController.swift
//  QuizPlease
//
//  Created by Владислав on 23.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let logoHeight: CGFloat = 164
    static let sideSpacing: CGFloat = 20
    static let arrowWidth: CGFloat = 16
    static let titleLogoSpacing: CGFloat = 35
}

/// Welcome View output
protocol WelcomeViewOutput: AnyObject {

    /// Welcome view did load
    func viewDidLoad()

    /// Welcome view did receive a tap to pick a city
    func didTapPickCity()

    /// Welcome view did receive a tap to continue
    func didTapContinue()
}

/// Welcome View input protocol
protocol WelcomeViewProtocol: AnyObject {

    /// Show or hide continue button
    func setContinueButton(hidden isHidden: Bool)

    /// Set selected city name
    func setSelectedCity(title: String)

    /// Animate transition to main menu
    func animateTransitionToMainMenu()

    /// Show an alert that client settings were not loaded
    func showErrorLoadingClientSettings()
}

/// Welcome View Controller
final class WelcomeViewController: UIViewController {

    // MARK: - Private Properties

    private let output: WelcomeViewOutput

    // MARK: - UI Elements

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .logoScreenBackground)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: .logoTemplateImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .gilroy(.bold, size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Привет!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private lazy var cityTextFieldView: TitledTextFieldView = {
        let textFieldView = TitledTextFieldView()
        textFieldView.isHidden = true
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.textField.isEnabled = false
        textFieldView.titleColor = .white.withAlphaComponent(0.5)
        textFieldView.textField.placeholderColor = .white.withAlphaComponent(0.7)
        textFieldView.textField.textColor = .white
        textFieldView.viewBorderColor = .white.withAlphaComponent(0.05)
        textFieldView.title = "Город"
        textFieldView.placeholder = "Выберите город из списка"
        textFieldView.addTapGestureRecognizer { self.didTapPickCity() }
        return textFieldView
    }()

    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: .arrowDown)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white.withAlphaComponent(0.3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var continueButton: BigButton = {
        let button = BigButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Продолжить", for: .normal)
        return button
    }()

    private lazy var logoImageViewDefaultConstraints: [NSLayoutConstraint] = [
        logoImageView.heightAnchor.constraint(
            equalToConstant: Constants.logoHeight),
        logoImageView.topAnchor.constraint(
            equalTo: view.layoutMarginsGuide.topAnchor,
            constant: Constants.sideSpacing),
        logoImageView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.sideSpacing),
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ]

    private lazy var logoImageViewLargeConstraints: [NSLayoutConstraint] = [
        logoImageView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 75),
        logoImageView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor),
        logoImageView.centerYAnchor.constraint(
            equalTo: view.layoutMarginsGuide.centerYAnchor,
            constant: -40),
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
    ]

    private lazy var logoImageViewMainMenuConstraints: [NSLayoutConstraint] = [
        logoImageView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16),
        logoImageView.topAnchor.constraint(
            equalTo: view.layoutMarginsGuide.topAnchor,
            constant: 10),
        logoImageView.widthAnchor.constraint(equalToConstant: 60),
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
    ]

    private lazy var activeLogoConstraints: [NSLayoutConstraint] = logoImageViewLargeConstraints {
        didSet {
            NSLayoutConstraint.deactivate(oldValue)
            NSLayoutConstraint.activate(activeLogoConstraints)
        }
    }

    // MARK: - Overrides

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Lifecycle

    init(output: WelcomeViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        configureViews()
        output.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeTransitionFromSplash()
    }

    // MARK: - Button Actions

    private func didTapPickCity() {
        output.didTapPickCity()
    }

    @objc
    private func didTapContinue() {
        output.didTapContinue()
    }

    // MARK: - Private Methods

    private func setupBackground() {
        if #available(iOS 13, *) {
            view.backgroundColor = .tertiarySystemGroupedBackground
        } else {
            view.backgroundColor = .systemBackgroundAdapted
        }

        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureViews() {
        cityTextFieldView.addSubview(accessoryImageView)

        // Add to view
        [
            logoImageView,
            titleLabel,
            cityTextFieldView,
            continueButton
        ].forEach(view.addSubview(_:))

        NSLayoutConstraint.activate(
            activeLogoConstraints +
            makeTitleLabelConstraints() +
            makeCityTextFieldViewConstraints() +
            makeAccessoryImageConstraints() +
            makeContinueButtonConstraints()
        )
    }

    private func makeTitleLabelConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: Constants.titleLogoSpacing),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.sideSpacing),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.sideSpacing)
        ]
    }

    private func makeCityTextFieldViewConstraints() -> [NSLayoutConstraint] {
        let screenCenterConstraint = cityTextFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        screenCenterConstraint.priority = .defaultLow
        return [
            cityTextFieldView.heightAnchor.constraint(equalToConstant: 70),
            cityTextFieldView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.sideSpacing),
            cityTextFieldView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.sideSpacing),
            screenCenterConstraint,
            cityTextFieldView.topAnchor.constraint(
                greaterThanOrEqualTo: titleLabel.bottomAnchor,
                constant: 2 * Constants.titleLogoSpacing)
        ]
    }

    private func makeAccessoryImageConstraints() -> [NSLayoutConstraint] {
        return [
            accessoryImageView.trailingAnchor.constraint(
                equalTo: cityTextFieldView.trailingAnchor,
                constant: -Constants.arrowWidth),
            accessoryImageView.widthAnchor.constraint(equalToConstant: Constants.arrowWidth),
            accessoryImageView.heightAnchor.constraint(equalTo: accessoryImageView.widthAnchor),
            accessoryImageView.centerYAnchor.constraint(equalTo: cityTextFieldView.centerYAnchor)
        ]
    }

    private func makeContinueButtonConstraints() -> [NSLayoutConstraint] {
        return [
            continueButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.sideSpacing),
            continueButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.sideSpacing),
            continueButton.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor,
                constant: -Constants.sideSpacing)
        ]
    }

    private func makeTransitionFromSplash() {
        [titleLabel, cityTextFieldView, continueButton].forEach { $0.isHidden = true }

        activeLogoConstraints = logoImageViewLargeConstraints
        cityTextFieldView.transform = CGAffineTransform(translationX: 0, y: 50)
        cityTextFieldView.alpha = 0
        view.setNeedsLayout()
        view.layoutIfNeeded()

        let logoImageAnimationDuration = 0.85
        UIView.animate(
            withDuration: logoImageAnimationDuration,
            delay: CATransaction.animationDuration(),
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0
        ) { [self] in
            activeLogoConstraints = logoImageViewDefaultConstraints
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }

        let delay = 0.4 * logoImageAnimationDuration
        UIView.animate(
            withDuration: 0.15,
            delay: CATransaction.animationDuration() + delay,
            options: .curveEaseOut
        ) { [self] in
            cityTextFieldView.isHidden = false
            cityTextFieldView.alpha = 1
            cityTextFieldView.transform = .identity
        }
    }
}

// MARK: - WelcomeViewProtocol

extension WelcomeViewController: WelcomeViewProtocol {

    func setContinueButton(hidden isHidden: Bool) {
        continueButton.isHidden = isHidden
    }

    func setSelectedCity(title: String) {
        cityTextFieldView.textField.text = title
    }

    func animateTransitionToMainMenu() {
        UIView.animate(withDuration: 0.25) { [self] in
            activeLogoConstraints = logoImageViewMainMenuConstraints
            continueButton.transform = CGAffineTransform(translationX: 0, y: 200)
            backgroundImageView.alpha = 0.5
            cityTextFieldView.alpha = 0
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    func showErrorLoadingClientSettings() {
        showErrorConnectingToServerAlert(
            title: "Ошибка",
            message: "Не удалось загрузить настройки выбранного города. " +
            "Пожалуйста, попробуйте повторить попытку позже или выберите другой город"
        )
    }
}

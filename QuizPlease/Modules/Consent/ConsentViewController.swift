//
//  ConsentViewController.swift
//  QuizPlease
//
//  Created on 14.03.2026.
//

import UIKit
import SafariServices

/// Consent screen shown on first app launch over the splash screen.
/// Uses `UISheetPresentationController` for a modern sheet presentation.
final class ConsentViewController: UIViewController {

    // MARK: - Properties

    var onConsentAccepted: (() -> Void)?

    private let webPageRouter: WebPageRouter = WebPageRouterImpl()

    // MARK: - UI Elements

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: .logoColoredImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать!"
        label.font = .gilroy(.bold, size: 24)
        label.textColor = .labelAdapted
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пожалуйста, ознакомьтесь\nс Политикой конфиденциальности\nи Пользовательским соглашением"
        label.font = .gilroy(.medium, size: 16)
        label.textColor = .labelAdapted
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let personalDataCheckbox = AgreementCheckboxView()
    private let privacyPolicyCheckbox = AgreementCheckboxView()

    private let continueButton: BigButton = {
        let button = BigButton()
        button.setTitle("Продолжить", for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCheckboxes()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        continueButton.addGradient(.lemonOrange, insertAt: 0)
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = .systemBackgroundAdapted
        isModalInPresentation = true

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let checkboxStack = UIStackView(arrangedSubviews: [
            personalDataCheckbox,
            privacyPolicyCheckbox
        ])
        checkboxStack.axis = .vertical
        checkboxStack.spacing = 20
        checkboxStack.translatesAutoresizingMaskIntoConstraints = false

        [logoImageView, titleLabel, subtitleLabel, checkboxStack, continueButton]
            .forEach(contentView.addSubview)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 124),
            logoImageView.heightAnchor.constraint(equalToConstant: 124),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            checkboxStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 64),
            checkboxStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkboxStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            continueButton.topAnchor.constraint(greaterThanOrEqualTo: checkboxStack.bottomAnchor, constant: 32),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])

        continueButton.addGradient(.lemonOrange, insertAt: 0)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }

    private func configureCheckboxes() {
        personalDataCheckbox.configure(
            text: "Даю согласие на обработку моих персональных данных для целей и на условиях, изложенных в Политике конфиденциальности",
            links: [
                .init(text: "согласие", url: AppSettings.privacyPolicyUrl),
                .init(text: "Политике конфиденциальности", url: AppSettings.privacyPolicyUrl)
            ]
        )

        privacyPolicyCheckbox.configure(
            text: "Я ознакомился с Политикой конфиденциальности",
            links: [
                .init(text: "Политикой конфиденциальности", url: AppSettings.privacyPolicyUrl)
            ]
        )

        personalDataCheckbox.onLinkTap = { [weak self] url in
            self?.openUrl(url)
        }

        privacyPolicyCheckbox.onLinkTap = { [weak self] url in
            self?.openUrl(url)
        }

        personalDataCheckbox.addTarget(self, action: #selector(checkboxChanged), for: .valueChanged)
        privacyPolicyCheckbox.addTarget(self, action: #selector(checkboxChanged), for: .valueChanged)
    }

    private func openUrl(_ url: URL) {
        webPageRouter.open(url: url)
    }

    private func updateContinueButton() {
        let allChecked = personalDataCheckbox.isSelected && privacyPolicyCheckbox.isSelected
        UIView.animate(withDuration: 0.2) {
            self.continueButton.isEnabled = allChecked
            self.continueButton.alpha = allChecked ? 1.0 : 0.5
        }
    }

    // MARK: - Actions

    @objc private func checkboxChanged() {
        updateContinueButton()
    }

    @objc private func continueButtonTapped() {
        DefaultsManager.shared.setConsentAccepted()
        onConsentAccepted?()
    }
}

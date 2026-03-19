//
//  ConsentViewController.swift
//  QuizPlease
//
//  Created on 14.03.2026.
//

import UIKit

/// Consent screen shown on first app launch over the splash screen.
/// Uses `UISheetPresentationController` for a modern sheet presentation.
final class ConsentViewController: UIViewController {

    private enum Layout {
        static let contentTopInset: CGFloat = 48
        static let contentHorizontalInset: CGFloat = 20
        static let contentBottomInset: CGFloat = 40
        static let interSectionSpacing: CGFloat = 32
        static let subtitleToCheckboxSpacing: CGFloat = 64
        static let minimumSheetHeightRatio: CGFloat = 0.85
    }

    // MARK: - Properties

    var onConsentAccepted: (() -> Void)?

    private let webPageRouter: WebPageRouter = WebPageRouterImpl()

    // MARK: - UI Elements

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: .logoColoredImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать!"
        label.font = .gilroy(.bold, size: 24)
        label.textColor = .labelAdapted
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пожалуйста, ознакомьтесь\nс Политикой конфиденциальности\nи Пользовательским соглашением"
        label.font = .gilroy(.medium, size: 16)
        label.textColor = .labelAdapted
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let personalDataCheckbox: AgreementCheckboxView = {
        let checkbox = AgreementCheckboxView()
        checkbox.checkboxColor = .lemon
        return checkbox
    }()

    private let privacyPolicyCheckbox: AgreementCheckboxView = {
        let checkbox = AgreementCheckboxView()
        checkbox.checkboxColor = .lemon
        return checkbox
    }()

    private let errorHapticsGenerator = UINotificationFeedbackGenerator()

    private let continueButton: BigButton = {
        let button = BigButton()
        button.setTitle("Продолжить", for: .normal)
        button.tintColor = .black
        return button
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCheckboxes()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        errorHapticsGenerator.prepare()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        continueButton.addGradient(.lemonOrange, insertAt: 0)
    }

    func preferredSheetHeight(maximumDetentValue: CGFloat) -> CGFloat {
        loadViewIfNeeded()
        view.layoutIfNeeded()

        let viewWidth = max(view.bounds.width, UIScreen.main.bounds.width)
        let contentWidth = viewWidth - (Layout.contentHorizontalInset * 2)
        let targetSize = CGSize(
            width: contentWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let contentHeight = contentStack.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        let totalHeight = Layout.contentTopInset + contentHeight + Layout.contentBottomInset
        let minimumSheetHeight = maximumDetentValue * Layout.minimumSheetHeightRatio

        return min(maximumDetentValue, max(minimumSheetHeight, totalHeight))
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = .backgroundOpaque
        view.isOpaque = true
        isModalInPresentation = true

        // Header stack: logo + title + subtitle
        let headerStack = UIStackView(arrangedSubviews: [
            logoImageView, titleLabel, subtitleLabel
        ])
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 0
        headerStack.setCustomSpacing(16, after: logoImageView)
        headerStack.setCustomSpacing(12, after: titleLabel)

        // Checkbox stack
        let checkboxStack = UIStackView(arrangedSubviews: [
            personalDataCheckbox, privacyPolicyCheckbox
        ])
        checkboxStack.axis = .vertical
        checkboxStack.spacing = 20

        // Spacer between subtitle and checkboxes
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: Layout.subtitleToCheckboxSpacing).isActive = true

        // Main content stack
        contentStack.addArrangedSubview(headerStack)
        contentStack.addArrangedSubview(spacerView)
        contentStack.addArrangedSubview(checkboxStack)
        contentStack.addArrangedSubview(continueButton)
        contentStack.setCustomSpacing(Layout.interSectionSpacing, after: checkboxStack)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Layout.contentTopInset),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layout.contentHorizontalInset),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layout.contentHorizontalInset),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Layout.contentBottomInset),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(Layout.contentHorizontalInset * 2)),

            logoImageView.widthAnchor.constraint(equalToConstant: 124),
            logoImageView.heightAnchor.constraint(equalToConstant: 124)
        ])

        continueButton.addGradient(.lemonOrange, insertAt: 0)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }

    private func configureCheckboxes() {
        personalDataCheckbox.configure(
            text: "Даю согласие на обработку моих персональных данных для целей и на условиях, изложенных в Политике конфиденциальности",
            links: [
                .init(text: "согласие", url: AppSettings.userAgreementUrl),
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

    private var uncheckedCheckboxes: [AgreementCheckboxView] {
        [personalDataCheckbox, privacyPolicyCheckbox].filter { !$0.isSelected }
    }

    // MARK: - Actions

    @objc private func checkboxChanged() {
        // No-op, validation happens on button tap
    }

    @objc private func continueButtonTapped() {
        let unchecked = uncheckedCheckboxes
        guard unchecked.isEmpty else {
            errorHapticsGenerator.notificationOccurred(.error)
            unchecked.forEach { $0.showError() }
            return
        }

        DefaultsManager.shared.setConsentAccepted()
        onConsentAccepted?()
    }
}

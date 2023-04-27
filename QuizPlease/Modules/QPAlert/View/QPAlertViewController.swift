//
//  QPAlertViewController.swift
//  QuizPlease
//
//  Created by Владислав on 27.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// QPAlert View input protocol
protocol QPAlertView: AnyObject {

    /// Set alert title
    func setTitle(_ title: String)

    /// Add button to alert 
    func addButton(model: QPAlertButtonModel)

    /// Replace existing buttons with the new ones
    func setButtons(_ buttons: [QPAlertButtonModel])

    /// Show alert on top view controller with animation
    func show()

    /// Hide alert with animation
    func hide()

    /// Hide alert with animation. Provides a completion block
    func hide(completion: (() -> Void)?)
}

private enum Constants {

    static let horizontalSpacing: CGFloat = 26
    static let titleTopSpacing: CGFloat = 20
    static let titleToButtonsSpacing: CGFloat = 24
    static let buttonStackSpacing: CGFloat = 16
    static let buttonsBottomSpacing: CGFloat = 20
    static let alertBottomSpacing: CGFloat = 40
}

final class QPAlertViewController: UIViewController {

    private let dimmedColor = UIColor.black.withAlphaComponent(0.5)
    private var buttons: [QPAlertButtonModel] = []

    // MARK: - UI Elements

    private let alertView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.dropShadow(
            radius: 25,
            offset: CGSize(width: 10, height: 6),
            opacity: 1
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .gilroy(.bold, size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.buttonStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    init(title: String) {
        self.titleLabel.text = title
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = dimmedColor
        makeLayout()
        hideAlert()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        alertView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        alertView.addGradient(.warmupItems)
        alertView.clipsToBounds = false
    }

    // MARK: - Private Methods

    private func makeLayout() {
        let itemStackView = UIStackView()
        itemStackView.axis = .vertical
        itemStackView.spacing = Constants.titleToButtonsSpacing
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        [
            titleLabel,
            buttonStackView
        ].forEach(itemStackView.addArrangedSubview(_:))

        alertView.addSubview(itemStackView)
        view.addSubview(alertView)
        NSLayoutConstraint.activate([
            alertView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.horizontalSpacing),
            alertView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.horizontalSpacing),
            alertView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -Constants.alertBottomSpacing),

            itemStackView.leadingAnchor.constraint(
                equalTo: alertView.leadingAnchor, constant: Constants.horizontalSpacing),
            itemStackView.trailingAnchor.constraint(
                equalTo: alertView.trailingAnchor, constant: -Constants.horizontalSpacing),
            itemStackView.topAnchor.constraint(
                equalTo: alertView.topAnchor, constant: Constants.titleTopSpacing),
            itemStackView.bottomAnchor.constraint(
                equalTo: alertView.bottomAnchor, constant: -Constants.buttonsBottomSpacing)
        ])
    }

    private func makeButton(model: QPAlertButtonModel) -> UIButton {
        let button = BigButton()
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(model.style.titleColor, for: .normal)
        button.backgroundColor = model.style.backgroundColor
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc
    private func buttonPressed(_ sender: BigButton) {
        guard let index = buttonStackView.arrangedSubviews.firstIndex(of: sender) else { return }
        buttons[index].tapAction?()
    }

    private func hideAlert() {
        alertView.alpha = 0
        alertView.transform = CGAffineTransform(translationX: 0, y: 500)
        view.backgroundColor = .clear
    }
}

// MARK: - QPAlertView

extension QPAlertViewController: QPAlertView {

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func addButton(model: QPAlertButtonModel) {
        buttons.append(model)
        buttonStackView.addArrangedSubview(makeButton(model: model))
    }

    func setButtons(_ buttons: [QPAlertButtonModel]) {
        self.buttons = buttons
        buttons.forEach { buttonStackView.addArrangedSubview(makeButton(model: $0)) }
    }

    func show() {
        hideAlert()
        alertView.alpha = 1
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0
        ) { [self] in
            alertView.transform = .identity
            view.backgroundColor = dimmedColor
        }
    }

    func hide(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) { [self] in
            hideAlert()
        } completion: { [self] _ in
            dismiss(animated: false)
            completion?()
        }
    }

    func hide() {
        hide(completion: nil)
    }
}

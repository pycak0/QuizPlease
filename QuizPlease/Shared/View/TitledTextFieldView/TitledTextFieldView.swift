//
//  TitledTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol TitledTextFieldViewDelegate: AnyObject {
    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String)
    func textFieldViewDidEndEditing(_ textFieldView: TitledTextFieldView)
}

extension TitledTextFieldViewDelegate {
    func textFieldViewDidEndEditing(_ textFieldView: TitledTextFieldView) {}
}

private enum Constants {
    static let offset: CGFloat = 14
    static let bottomInset: CGFloat = -8
}

@IBDesignable
class TitledTextFieldView: UIView {
    weak var delegate: TitledTextFieldViewDelegate?

    // MARK: - UI
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = self.placeholder
        textField.font = .gilroy(.semibold, size: 16)
        return textField
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.semibold, size: 12)
        label.textColor = titleColor
        label.contentMode = .left
        label.text = self.title
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    // MARK: - Inspectables
    @IBInspectable
    var title: String = "Title" {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var placeholder: String = "Placeholder" {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var titleFontName: String? = FontSet.Gilroy.semibold.fileName {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var titleFontSize: CGFloat = 12 {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var textFontName: String? = FontSet.Gilroy.semibold.fileName {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var textFontSize: CGFloat = 16 {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var viewBorderColor: UIColor = UIColor.lightGray.withAlphaComponent(0.3) {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var viewBorderWidth: CGFloat = 2 {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var viewCornerRadius: CGFloat = 20 {
        didSet {
            updateAppearance()
        }
    }

    @IBInspectable
    var titleColor: UIColor = .darkGray {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: 70
        )
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        configure()
    }

    override func prepareForInterfaceBuilder() {
        commonInit()
        super.prepareForInterfaceBuilder()
    }

    private func commonInit() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(textField)
        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.offset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.offset)
        ])

        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.offset),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.bottomInset)
        ])
    }

    private func configure() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        addGestureRecognizer(tapRecognizer)

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    // MARK: - Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAppearance()
    }

    func updateAppearance() {
        titleLabel.text = title
        textField.placeholder = placeholder
        layer.borderColor = viewBorderColor.cgColor
        layer.borderWidth = viewBorderWidth
        layer.cornerRadius = viewCornerRadius
        layer.masksToBounds = viewCornerRadius > 0

        titleLabel.font = titleFontName.map { UIFont(name: $0, size: titleFontSize) }
            ?? .systemFont(ofSize: titleFontSize, weight: .semibold)
        textField.font = textFontName.map { UIFont(name: $0, size: textFontSize) }
            ?? .systemFont(ofSize: textFontSize, weight: .semibold)
    }

    @objc
    private func startEditing() {
        guard !textField.isFirstResponder else { return }
        textField.becomeFirstResponder()
    }

    private func updateEditingAppearance() {
        UIView.transition(with: titleLabel, duration: 0.2, options: .transitionCrossDissolve) { [self] in
            titleLabel.textColor = textField.isEditing ? nil : .darkGray
        } completion: { _ in }
    }
}

// MARK: - UITextFieldDelegate
extension TitledTextFieldView: UITextFieldDelegate {
    /// You can override this method to provide custom delegate calls,
    /// but make sure to call `super.textFieldDidEndEditing(_:)`
    /// at the end of your implementation to preserve correct behavior.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateEditingAppearance()
    }

    /// You can override this method to provide custom delegate calls,
    /// but make sure to call `super.textFieldDidEndEditing(_:)`
    /// at the end of your implementation to preserve correct behavior.
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateEditingAppearance()
        delegate?.textFieldViewDidEndEditing(self)
    }

    /// You can override this method to provide custom delegate calls.
    ///
    /// Default implementation of this method calls
    /// `textFieldView(_:didChangeTextField:didCompleteMask:)` delegate method.
    ///
    /// When overriding this class, you must also call this delegate method,
    /// or (preferred) you can call `super.textFieldDidChange(_:)`
    /// at the end of your implementation/
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldView(self, didChangeTextField: textField.text ?? "")
    }
}

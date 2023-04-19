//
//  TitledTextView.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 19.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

protocol TitledTextViewDelegate: AnyObject {
    func textView(_ textView: TitledTextView, didChangeText text: String)
    func textViewDidEndEditing(_ textView: TitledTextView)
}

extension TitledTextViewDelegate {
    func textViewDidEndEditing(_ textView: TitledTextView) {}
}

private enum Constants {
    static let topInset: CGFloat = 14
    static let horizontalInset: CGFloat = 14
    static let bottomInset: CGFloat = 14
    static let titleSpacing: CGFloat = 4
}

@IBDesignable
class TitledTextView: UIView {
    weak var delegate: TitledTextViewDelegate?

    // MARK: - UI Elements

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .gilroy(.semibold, size: 16)
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.semibold, size: 12)
        label.textColor = titleColor
        label.contentMode = .left
        label.text = self.title
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.semibold, size: 16)
        label.textColor = .placeholderTextAdapted
        label.contentMode = .left
        label.text = placeholder
        label.translatesAutoresizingMaskIntoConstraints = false
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
    var text: String {
        get { textView.text }
        set {
            textView.text = newValue
            updatePlaceholder()
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

    var autocapitalizationType: UITextAutocapitalizationType {
        get { textView.autocapitalizationType }
        set { textView.autocapitalizationType = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { textView.keyboardType }
        set { textView.keyboardType = newValue }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureTapRecognizer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        configureTapRecognizer()
    }

    override func prepareForInterfaceBuilder() {
        commonInit()
        super.prepareForInterfaceBuilder()
    }

    private func commonInit() {
        backgroundColor = .clear
        makeConstraints()
    }

    private func makeConstraints() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topInset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),

            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.titleSpacing),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomInset),

            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: textView.bottomAnchor)
        ])
    }

    private func configureTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        addGestureRecognizer(tapRecognizer)
    }

    // MARK: - Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAppearance()
    }

    func updateAppearance() {
        titleLabel.text = title
        placeholderLabel.text = placeholder
        layer.borderColor = viewBorderColor.cgColor
        layer.borderWidth = viewBorderWidth
        layer.cornerRadius = viewCornerRadius
        layer.masksToBounds = viewCornerRadius > 0

        titleLabel.font = titleFontName.map { UIFont(name: $0, size: titleFontSize) }
            ?? .systemFont(ofSize: titleFontSize, weight: .semibold)

        let textFont = textFontName.map { UIFont(name: $0, size: textFontSize) }
            ?? .systemFont(ofSize: textFontSize, weight: .semibold)
        placeholderLabel.font = textFont
        textView.font = textFont
    }

    override func becomeFirstResponder() -> Bool {
        startEditing()
    }

    @discardableResult
    @objc
    private func startEditing() -> Bool {
        guard !textView.isFirstResponder else { return true }
        return textView.becomeFirstResponder()
    }

    private func setEditingAppearance(enabled: Bool) {
        UIView.transition(with: titleLabel, duration: 0.2, options: .transitionCrossDissolve) { [self] in
            titleLabel.textColor = enabled ? nil : .darkGray
        } completion: { _ in }
    }

    private func updatePlaceholder() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - UITextViewDelegate

extension TitledTextView: UITextViewDelegate {

    /// You can override this method to provide custom delegate calls,
    /// but make sure to call `super.textViewDidBeginEditing(_:)`
    /// at the end of your implementation to preserve correct behavior.
    func textViewDidBeginEditing(_ textView: UITextView) {
        setEditingAppearance(enabled: true)
    }

    /// You can override this method to provide custom delegate calls,
    /// but make sure to call `super.textViewDidEndEditing(_:)`
    /// at the end of your implementation to preserve correct behavior.
    func textViewDidEndEditing(_ textView: UITextView) {
        setEditingAppearance(enabled: false)
        delegate?.textViewDidEndEditing(self)
    }

    /// You can override this method to provide custom delegate calls.
    ///
    /// When overriding this class, you must also call this delegate method,
    /// or (preferred) you can call `super.textViewDidChange(_:)`
    /// at the end of your implementation/
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholder()
        delegate?.textView(self, didChangeText: textView.text ?? "")
    }
}

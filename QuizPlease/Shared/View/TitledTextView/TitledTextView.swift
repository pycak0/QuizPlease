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

    /// Set a limit to the `TitledTextView`'s `text` `contentSize`
    /// with given max number of lines. Default value of this property is 0 - no limit.
    ///
    /// When the current number of lines in the text view is bigger than the limit,
    /// text view stops increasing its height and becomes scrollable.
    ///
    /// - Note: This value is non-negative. Setting values below zero will assign 0.
    @NonNegative
    var linesLimit: Int = 0 {
        didSet {
            let height = CGFloat(linesLimit) * heightForOneLine
            maximumHeight = height > 0 ? height : nil
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

    // MARK: - Private Properties

    private var maximumHeight: CGFloat? {
        didSet {
            updateMaxHeight()
        }
    }

    private lazy var maxHeightConstraint: NSLayoutConstraint = {
        textView.heightAnchor.constraint(equalToConstant: textView.contentSize.height)
    }()

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

    private lazy var titleLabel: UILabel = {
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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        configureLayout()
        super.prepareForInterfaceBuilder()
    }

    private func commonInit() {
        configureLayout()
        configureTapRecognizer()
    }

    private func configureLayout() {
        backgroundColor = .clear
        makeConstraints()
        updateMaxHeight()
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

    private func updateMaxHeight() {
        let maximumHeight = maximumHeight ?? CGFloat.greatestFiniteMagnitude
        let isOversize = textView.contentSize.height >= maximumHeight
        maxHeightConstraint.isActive = isOversize
        maxHeightConstraint.constant = maximumHeight
        textView.isScrollEnabled = isOversize
        textView.alwaysBounceVertical = isOversize
        textView.bounces = isOversize
        layoutIfNeeded()
    }

    private lazy var heightForOneLine: CGFloat = {
        let font = (textFontName.map { UIFont(name: $0, size: textFontSize) })
            ?? .systemFont(ofSize: textFontSize, weight: .semibold)
        let constraintSize = CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        let boundingBox = "A".boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font!],
            context: nil
        )
        return boundingBox.height
    }()
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
        updateMaxHeight()
        delegate?.textView(self, didChangeText: textView.text ?? "")
    }
}

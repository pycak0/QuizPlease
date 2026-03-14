//
//  AgreementCheckboxView.swift
//  QuizPlease
//
//  Created on 14.03.2026.
//

import UIKit

/// A reusable checkbox with attributed text that supports tappable links.
/// Designed for consent/agreement screens where text contains interactive links.
final class AgreementCheckboxView: UIControl {

    /// Model describing a tappable link within the checkbox text
    struct Link {
        let text: String
        let url: URL
    }

    /// Haptics can be enabled only when user presses the checkbox
    var isHapticsEnabled: Bool = true

    /// Color used for the checkbox when selected. Defaults to `lightGreen`.
    var checkboxColor: UIColor = .lightGreen {
        didSet { updateCheckboxAppearance() }
    }

    // MARK: - Private Properties

    private let hapticsGenerator = UIImpactFeedbackGenerator(style: .medium)
    private var links: [Link] = []

    /// Callback when a link inside the text is tapped
    var onLinkTap: ((URL) -> Void)?

    // MARK: - UI Elements

    private let checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var _isSelected: Bool = false {
        didSet {
            updateCheckboxAppearance()
        }
    }

    // MARK: - Overrides

    override var isSelected: Bool {
        get { _isSelected }
        set { _isSelected = newValue }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeLayout()
        setupGestures()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    /// Configure the checkbox with plain text and optional tappable links
    /// - Parameters:
    ///   - text: Full text to display
    ///   - links: Parts of the text that should be tappable links
    ///   - font: Font for the text
    ///   - textColor: Default text color
    ///   - linkColor: Color for tappable links
    func configure(
        text: String,
        links: [Link] = [],
        font: UIFont = .gilroy(.medium, size: 14),
        textColor: UIColor = .labelAdapted,
        linkColor: UIColor = .themePurple
    ) {
        self.links = links

        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: textColor
            ]
        )

        for link in links {
            if let range = text.range(of: link.text) {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttributes([
                    .foregroundColor: linkColor,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .link: link.url
                ], range: nsRange)
            }
        }

        textView.attributedText = attributedString
        textView.linkTextAttributes = [
            .foregroundColor: linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

    /// Highlight the checkbox with error state (red border + shake + haptics)
    func showError() {
        checkboxImageView.layer.borderColor = UIColor.systemRed.cgColor
        shake()
    }

    /// Reset error state back to normal border
    func hideError() {
        guard !_isSelected else { return }
        checkboxImageView.layer.borderColor = UIColor.systemGray3.cgColor
    }

    // MARK: - Private Methods

    private func makeLayout() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(checkboxImageView)
        stackView.addArrangedSubview(textView)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            checkboxImageView.widthAnchor.constraint(equalToConstant: 28),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 28)
        ])

        textView.delegate = self
        updateCheckboxAppearance()
    }

    private func setupGestures() {
        let checkboxTap = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
        checkboxImageView.isUserInteractionEnabled = true
        checkboxImageView.addGestureRecognizer(checkboxTap)
    }

    @objc private func checkboxTapped() {
        _isSelected.toggle()
        sendActions(for: .valueChanged)

        if isHapticsEnabled {
            hapticsGenerator.impactOccurred()
        }

        if _isSelected {
            // Reset error border when user checks the checkbox
            checkboxImageView.layer.borderColor = checkboxColor.cgColor
        }
    }

    private func updateCheckboxAppearance() {
        if _isSelected {
            checkboxImageView.backgroundColor = checkboxColor
            checkboxImageView.layer.borderColor = checkboxColor.cgColor
            checkboxImageView.image = UIImage(systemName: "checkmark")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .bold))
            checkboxImageView.tintColor = .white
        } else {
            checkboxImageView.backgroundColor = .clear
            checkboxImageView.layer.borderColor = checkboxColor.cgColor
            checkboxImageView.image = nil
        }
    }
}

// MARK: - UITextViewDelegate

extension AgreementCheckboxView: UITextViewDelegate {

    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        onLinkTap?(URL)
        return false
    }
}

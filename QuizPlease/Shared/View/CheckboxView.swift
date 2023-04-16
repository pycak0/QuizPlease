//
//  CheckboxView.swift
//  QuizPlease
//
//  Created by Владислав on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let imageSide: CGFloat = 40
}

/// Checkbox view
final class CheckboxView: UIControl {

    /// Checkbox view title 
    var title: String? {
        get { textLabel.text }
        set { textLabel.text = newValue }
    }

    /// Haptics can be enabled only when user presses the checkbox
    var isHapticsEnabled: Bool = true

    // MARK: - Private Properties

    private let hapticsGenerator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.semibold, size: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var _isSelected: Bool = false {
        didSet {
            imageView.image = _isSelected ? UIImage(named: "rectDot") : nil
        }
    }

    // MARK: - Overrides

    /// Property indicating whether checkbox is selected or not
    override var isSelected: Bool {
        get { _isSelected }
        set { _isSelected = newValue }
    }

    override var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
            imageView.layer.borderColor = tintColor.cgColor
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Constants.imageSide)
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeLayout()
        addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            self._isSelected.toggle()
            if self.isHapticsEnabled {
                self.hapticsGenerator.impactOccurred()
            }
            self.sendActions(for: .valueChanged)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            imageView,
            textLabel
        ].forEach(stackView.addArrangedSubview(_:))

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSide),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}

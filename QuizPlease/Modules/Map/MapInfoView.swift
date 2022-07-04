//
//  MapInfoView.swift
//  QuizPlease
//
//  Created by Владислав on 08.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit
import MapKit

protocol MapInfoViewDelegate: AnyObject {

    /// Close button was pressed
    func mapInfoViewDidPressClose(_ mapInfoView: MapInfoView)

    /// Directions button was pressed
    func mapInfoViewDidPressDirections(_ mapInfoView: MapInfoView)

    /// View was swiped to close
    func mapInfoViewDidSwipeToClose(_ mapInfoView: MapInfoView)

    /// Provide user location to show distance from from place to it
    func userLocation() -> CLLocation?
}

final class MapInfoView: UIView {

    enum Constants {
        static let spacing: CGFloat = 16
        static let buttonHeight: CGFloat = 24
    }

    // MARK: - State Properties

    weak var delegate: MapInfoViewDelegate?

    var place: Place? {
        didSet {
            updateText()
        }
    }

    // MARK: - Private Properties

    private let distanceFormatter = MKDistanceFormatter()

    private let titleLabel: UILabel = {
        let label = CopyableLabel()
        label.font = .gilroy(.semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addressLabel: UILabel = {
        let label = CopyableLabel()
        label.font = .gilroy(.medium, size: 14)
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.medium, size: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage.xmark?.withScale(.small)
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemGray6Adapted
        button.tintColor = .darkGray
        button.layer.cornerRadius = Constants.buttonHeight / 2
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var directionsButton: UIButton = {
        let button = ScalingButton()
        button.titleLabel?.font = .gilroy(.semibold, size: 14)
        button.setTitle("Маршрут", for: .normal)
        button.backgroundColor = .darkGray
        button.tintColor = .white
        button.layer.cornerRadius = Constants.buttonHeight / 2
        button.addTarget(self, action: #selector(didTapDirections), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleEdgeInsets = .init(vertical: 0, horizontal: 8)
        return button
    }()

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackgroundAdapted
        configureViews()
        updateText()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func show(animated: Bool, completion: (() -> Void)? = nil) {
        guard animated else {
            transform = .identity
            alpha = 1
            isHidden = false
            completion?()
            return
        }

        isHidden = false
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: bounds.height + 20)
        UIView.animate(
            withDuration: 0.3,
            dampingRatio: 0.8,
            animations: { [self] in
                transform = .identity
                alpha = 1
            },
            completion: { _ in
                completion?()
            }
        )
    }

    func hide(animated: Bool, completion: (() -> Void)?) {
        guard animated else {
            transform = .identity
            alpha = 0
            isHidden = true
            completion?()
            return
        }

        UIView.animate(withDuration: 0.15) { [self] in
            transform = CGAffineTransform(translationX: 0, y: bounds.height + 20)
        } completion: { [self] _ in
            transform = .identity
            alpha = 0
            isHidden = true
            completion?()
        }
    }

    // MARK: - Private Methods

    private func configureViews() {
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: Constants.buttonHeight),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
           titleLabel,
           addressLabel,
           Spacer(),
           makeHorizontalStack()
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.spacing),
            stackView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.spacing),
            directionsButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        addGestureRecognizer(gestureRecognizer)
    }

    private func makeHorizontalStack() -> UIView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        [
            directionsButton,
            distanceLabel,
            Spacer()
        ].forEach {
            horizontalStack.addArrangedSubview($0)
        }
        return horizontalStack
    }

    // MARK: - Update Text

    private func updateText() {
        titleLabel.text = place?.title
        addressLabel.text = place?.fullAddress

        if let placeCoordinate = place?.coordinate,
           let location = delegate?.userLocation() {
            distanceLabel.isHidden = false

            let placeLocation = CLLocation(
                latitude: placeCoordinate.latitude,
                longitude: placeCoordinate.longitude
            )
            let distance = location.distance(from: placeLocation)
            distanceLabel.text = "• \(distanceFormatter.string(fromDistance: distance))"

        } else {
            distanceLabel.isHidden = true
        }
    }

    @objc private func didTapClose() {
        delegate?.mapInfoViewDidPressClose(self)
    }

    @objc private func didTapDirections() {
        delegate?.mapInfoViewDidPressDirections(self)
    }

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        let offsetY = sender.translation(in: view).y
        let translationY = offsetY > 0 ? offsetY : -sqrt(-offsetY)

        switch sender.state {
        case .began, .changed:
            transform = CGAffineTransform(translationX: 0, y: translationY)

        case .ended:
            let velocity = sender.velocity(in: view).y
            guard offsetY > 0 else {
                resetView()
                return
            }
            if offsetY >= bounds.height / 3 || velocity > 700 {
                delegate?.mapInfoViewDidSwipeToClose(self)
                return
            }
            fallthrough

        default:
            resetView()
        }
    }

    private func resetView() {
        UIView.animate(
            withDuration: 0.3,
            dampingRatio: 0.6,
            animations: {
                self.transform = .identity
            },
            completion: nil
        )
    }
}

// MARK: - UIView + animate

private extension UIView {
    static func animate(
        withDuration duration: CGFloat,
        dampingRatio: CGFloat,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: 0,
            options: [],
            animations: animations,
            completion: completion
        )
    }
}

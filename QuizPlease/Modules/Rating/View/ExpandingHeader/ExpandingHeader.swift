//
// MARK: ExpandingHeader.swift
//  ExpandingTableViewHeader
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

public class ExpandingHeader: UIView {
    // MARK: - Constants
    static let nibName = "\(ExpandingHeader.self)"
    static let collapsedHeight: CGFloat = 140
    static let expandedHeight: CGFloat = 320
    static let gradientExpandedHeight: CGFloat = ExpandingHeader.expandedHeight - 65
    static let itemsCornerRadius: CGFloat = 20
    static let themeColor = UIColor.ripePlum.withAlphaComponent(0.5)

    // MARK: - UI
    private unowned var gradientLayer: CAGradientLayer!

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var footLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var selectedGameTypeLabel: UILabel!

    @IBOutlet private weak var collapseButton: UIButton! {
        didSet { collapseButton.tintColor = ExpandingHeader.themeColor }
    }

    @IBOutlet private weak var expandView: UIView! {
        didSet {
            expandView.layer.cornerRadius = ExpandingHeader.itemsCornerRadius
            expandView.addGestureRecognizer(UITapGestureRecognizer(
                target: self, action: #selector(toggleExpanded)))
        }
    }

    @IBOutlet private weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
            searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            searchField.tintColor = .lemon
            searchField.layer.cornerRadius = ExpandingHeader.itemsCornerRadius
            searchField.backgroundColor = ExpandingHeader.themeColor
            searchField.setImage(UIImage(named: "search"))
            searchField.attributedPlaceholder = makePlaceholder(textColor: .white)
        }
    }

    @IBOutlet private weak var segmentControl: HBSegmentedControl! {
        didSet {
            segmentControl.dampingRatio = 0.7
            segmentControl.font = .gilroy(.bold, size: 16)
            segmentControl.backgroundColor = ExpandingHeader.themeColor
            segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        }
    }

    @IBOutlet private weak var gameTypesView: UIView! {
        didSet {
            gameTypesView.layer.cornerRadius = ExpandingHeader.itemsCornerRadius
            gameTypesView.backgroundColor = ExpandingHeader.themeColor
            gameTypesView.addTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                self.delegate?.didPressGameTypeView(in: self) { selectedName in
                    self.selectedGameTypeLabel.text = selectedName
                }
            }
        }
    }

    // MARK: - Delegates
    public weak var delegate: ExpandingHeaderDelegate?

    public weak var dataSource: ExpandingHeaderDataSource? {
        didSet {
            guard let dataSource = dataSource else { return }
            var items = [String]()
            for i in 0..<dataSource.numberOfSegmentControlItems(in: self) {
                let name = dataSource.expandingHeader(self, titleForSegmentAtIndex: i)
                items.append(name)
            }
            segmentControl.items = items
            segmentControl.selectedIndex = dataSource.expandingHeaderSelectedSegmentIndex(self)
            selectedGameTypeLabel.text = dataSource.expandingHeaderInitialSelectedGameType(self)
        }
    }

    public var isExpanded = false {
        didSet { setExpanded(isExpanded) }
    }

    public func setFooterContent(city: String, gameType: String, season: String) {
        footLabel.text = "Рейтинг \(gameType) \(season) в городе: \(city)"
    }

    // MARK: - Set Expanded
    private func setExpanded(_ isExpanded: Bool) {
        if !isExpanded { endEditing(true) }

        let height: CGFloat = isExpanded ? ExpandingHeader.expandedHeight : ExpandingHeader.collapsedHeight
        let grHeight: CGFloat = isExpanded ? ExpandingHeader.gradientExpandedHeight : 58

        let alpha: CGFloat = isExpanded ? 0 : 1
        let opacity: Float = isExpanded ? 1 : 0

        self.gradientLayer.frame.setHeight(grHeight)
        self.gradientLayer.opacity = opacity
        UIView.animate(
            withDuration: CATransaction.animationDuration(),
            delay: 0,
            options: .layoutSubviews,
            animations: {
                // self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
                self.frame.setHeight(height)

                self.setItemsHidden(!isExpanded)
                // self.labels.forEach { $0.isHidden = !self.expanded }
                self.expandView.isHidden = isExpanded
                self.expandView.alpha = alpha
                self.layoutIfNeeded()

                self.delegate?.expandingHeader(self, didChangeStateTo: isExpanded)
            },
            completion: nil
        )
    }

    @IBAction private func collapseButtonPressed(_ sender: Any) {
        isExpanded = false
    }

    @objc
    private func toggleExpanded() {
        isExpanded.toggle()
        // setExpanded(isExpanded)
    }

    private func setItemsHidden(_ isHidden: Bool) {
        let number = stackView.arrangedSubviews.count - 1
        for i in 1...number {
            stackView.arrangedSubviews[i].isHidden = isHidden
            stackView.arrangedSubviews[i].alpha = isHidden ? 0 : 1
        }
    }

    // MARK: - Segment Changed
    @objc
    private func segmentChanged() {
        delegate?.expandingHeader(self, didChange: segmentControl.selectedIndex)
    }

    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }

    private func xibSetup() {
        Bundle.main.loadNibNamed(ExpandingHeader.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Awake from Nib
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
        setExpanded(isExpanded)
    }

    private func setupGradient() {
        let origin = self.frame.origin
        let size = CGSize(width: UIScreen.main.bounds.width, height: ExpandingHeader.gradientExpandedHeight)
        self.addGradient(
            colors: [.systemBlue, .systemPurple],
            frame: CGRect(origin: origin, size: size),
            insertAt: 0
        )
        gradientLayer = self.layer.sublayers?.first as? CAGradientLayer
    }

    private func makePlaceholder(textColor: UIColor) -> NSAttributedString {
        NSAttributedString(
            string: "Поиск",
            attributes: [
                NSAttributedString.Key.font: UIFont.gilroy(.bold, size: 16),
                NSAttributedString.Key.foregroundColor: textColor
            ]
        )
    }
}

// MARK: - UITextFieldDelegate
extension ExpandingHeader: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = makePlaceholder(textColor: UIColor.white.withAlphaComponent(0.7))
        delegate?.expandingHeaderDidBeginEditingQuery(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = makePlaceholder(textColor: .white)
        delegate?.expandingHeader(self, didEndSearchingWith: textField.text ?? "")
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.expandingHeader(self, didPressReturnButtonWith: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}

extension ExpandingHeader {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        delegate?.expandingHeader(self, didChange: query)
    }
}

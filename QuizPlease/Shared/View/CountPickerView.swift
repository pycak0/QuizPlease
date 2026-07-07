//
//  CountPickerView.swift
//  TestPickCount
//
//  Created by Владислав on 19.09.2020.
//

import UIKit
import CoreHaptics

// MARK: - Delegate Protocol

protocol CountPickerViewDelegate: AnyObject {

    /// Tells the delegate that selected value is changed (only when by user, not via `setSelectedButton(at:)` method).
    ///
    /// The value of `number` is calculated according to the specified `startCount` value.
    /// For example, if the new selected index is `1` and the `startCount` is `2`, the `number` will be equal to `3`.
    func countPicker(_ picker: CountPickerView, didChangeSelectedNumber number: Int)

    /// Tells the delegate that user did end interactions with count picker.
    func countPickerDidEndEditing(_ picker: CountPickerView)
}

extension CountPickerViewDelegate {

    func countPickerDidEndEditing(_ picker: CountPickerView) {}
}

// MARK: - CircleButton

private class CircleButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

@IBDesignable
final class CountPickerView: UIView {

    private let hapticsGenerator = UISelectionFeedbackGenerator()

    // MARK: - UI

    private let vStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 16
        return vStack
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.isHidden = title.count == 0
        return titleLabel
    }()

    private let pickerView = UIView()

    private lazy var pickerLine: UIView = {
        let pickerLine = UIView(frame: pickerView.bounds)
        pickerLine.backgroundColor = pickerBackgroundColor
        return pickerLine
    }()

    private let pickerStack: UIStackView = {
        let pickerStack = UIStackView()
        pickerStack.axis = .horizontal
        pickerStack.spacing = 10
        pickerStack.distribution = .fill
        return pickerStack
    }()

    private var buttons = [UIButton]()
    private var buttonAspectConstraints = [NSLayoutConstraint]()
    private(set) var selectedIndex: Int = 0

    weak var delegate: CountPickerViewDelegate?

    // MARK: - IBInspectable

    @IBInspectable
    var startCount: Int = 2 {
        didSet { updateButtonViews() }
    }

    @IBInspectable
    var maxButtonsCount: Int = 8 {
        didSet {
            setButtons()
            setSelectedButton(at: maxButtonsCount - 1, animated: true)
        }
    }

    @IBInspectable
    var unselectedImage: UIImage? = UIImage(named: "human") {
        didSet { updateButtonViews() }
    }

    @IBInspectable
    var selectedColor: UIColor = .systemBlue {
        didSet { updateButtonViews() }
    }

    @IBInspectable
    var pickerBackgroundColor: UIColor? = .white {
        didSet { updateButtonViews() }
    }

    @IBInspectable
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title.count == 0
        }
    }

    @IBInspectable
    var buttonsTitleColor: UIColor = .white {
        didSet { updateButtonViews() }
    }

    @IBInspectable
    var buttonsCornerRadius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }

    var buttonsTitleFont: UIFont? = .systemFont(ofSize: 16, weight: .semibold) {
        didSet { updateButtonViews() }
    }

    /// When set, overrides sequential numbering (`startCount`-based).
    /// Each button shows `customValues[index]` instead of `index + startCount`.
    var customValues: [Int]? {
        didSet {
            setButtons()
            if let customValues, !customValues.isEmpty {
                setSelectedButton(at: 0, animated: false)
            }
        }
    }

    var buttonAccessibilityIdentifierPrefix: String? {
        didSet { updateButtonViews() }
    }

    // MARK: - Update Selected Button

    /// This method does not call any delegate methods
    func setSelectedButton(at index: Int, animated: Bool) {
        deselectAllButtons(animated: animated)
        guard index >= 0 && index < buttons.count else { return }
        selectedIndex = index
        // let selectedNumber = selectedIndex + startCount
        let selectedButton = buttons[index]
        select(selectedButton, animated: animated)
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Touches

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectButton(with: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectButton(with: touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        didEndEditing()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        didEndEditing()
    }

    // MARK: - Private Methods

    private func didEndEditing() {
        delegate?.countPickerDidEndEditing(self)
    }

    private func selectButton(with touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: pickerStack) else { return }
        for (index, item) in buttons.enumerated() {
            if item.frame.minX <= location.x && location.x <= item.frame.maxX {
                if selectedIndex != index {
                    pickerButtonPressed(at: index)
                }
                break
            }
        }
    }

    // MARK: - Count Button Pressed

    @objc
    private func pickerButtonPressed(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender), index != selectedIndex else { return }
        pickerButtonPressed(at: index)
    }

    private func pickerButtonPressed(at index: Int) {
        hapticsGenerator.selectionChanged()
        setSelectedButton(at: index, animated: true)
        delegate?.countPicker(self, didChangeSelectedNumber: valueForButton(at: index))
    }

    private func valueForButton(at index: Int) -> Int {
        if let customValues, index < customValues.count {
            return customValues[index]
        }
        return index + startCount
    }

    // MARK: - Set Buttons

    private func setButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        NSLayoutConstraint.deactivate(buttonAspectConstraints)
        buttonAspectConstraints.removeAll()

        let count = customValues?.count ?? maxButtonsCount
        for i in 0..<count {
            let button = CircleButton()
            button.isUserInteractionEnabled = false
            updateView(for: button, at: i)
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: [.touchUpInside])
            button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            // Prefer square (circle), breakable when too many buttons
            let aspect = button.widthAnchor.constraint(equalTo: button.heightAnchor)
            aspect.priority = UILayoutPriority(900)
            buttonAspectConstraints.append(aspect)

            // Chain all buttons to equal width so they compress uniformly
            if let firstButton = buttons.first {
                let equalWidth = button.widthAnchor.constraint(equalTo: firstButton.widthAnchor)
                equalWidth.priority = .required
                buttonAspectConstraints.append(equalWidth)
            }

            buttons.append(button)
            pickerStack.addArrangedSubview(button)
        }
        NSLayoutConstraint.activate(buttonAspectConstraints)
    }

    // MARK: - Update Button Views

    private func updateButtonViews() {
        for (i, button) in buttons.enumerated() {
            updateView(for: button, at: i)
        }
        pickerLine.backgroundColor = pickerBackgroundColor
        setSelectedButton(at: maxButtonsCount - 1, animated: false)
    }

    private func updateView(for button: UIButton, at index: Int) {
        let value = valueForButton(at: index)
        button.setImage(unselectedImage, for: .normal)
        button.setImage(nil, for: .highlighted)
        button.setImage(nil, for: .selected)
        button.setTitle("", for: .normal)
        button.setTitle("\(value)", for: .selected)
        button.titleLabel?.font = buttonsTitleFont
        button.setTitleColor(buttonsTitleColor, for: .normal)
        button.backgroundColor = button.isSelected ? selectedColor : pickerBackgroundColor
        button.isAccessibilityElement = true
        button.accessibilityLabel = "\(value)"
        button.accessibilityIdentifier = buttonAccessibilityIdentifierPrefix.map { "\($0).\(value)" }
        // button.layer.cornerRadius = buttonsCornerRadius
    }

    // MARK: - Select

    /// - parameter number: The value to set as the button's title
    private func select(_ button: UIButton, animated: Bool = true) {
        let scale: CGFloat = 1.1
        button.isSelected = true
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            // button.setTitle("\(number)", for: .normal)
            button.setImage(nil, for: .normal)
            button.backgroundColor = self.selectedColor
            button.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    // MARK: - Deselect

    private func deselect(_ button: UIButton?, animated: Bool) {
        button?.isSelected = false
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            button?.setImage(self.unselectedImage, for: .normal)
           // button?.setTitle("", for: .normal)
            button?.backgroundColor = self.pickerBackgroundColor
            button?.transform = .identity
        }
    }

    private func deselectAllButtons(animated: Bool) {
        buttons.forEach { deselect($0, animated: animated) }
    }

    // MARK: - Setup View
    private func setupView() {
        addSubview(vStack)
        activateConstraints(for: vStack, fillInto: self)

        vStack.addArrangedSubview(titleLabel)
        activateTitleConstraints()

        vStack.addArrangedSubview(pickerView)
        pickerView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        pickerView.addSubview(pickerLine)
        activatePickerLineConstraints()

        pickerView.addSubview(pickerStack)
        pickerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerStack.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
            pickerStack.topAnchor.constraint(equalTo: pickerView.topAnchor),
            pickerStack.trailingAnchor.constraint(lessThanOrEqualTo: pickerView.trailingAnchor),
            pickerStack.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor)
        ])
        setButtons()
        setSelectedButton(at: maxButtonsCount - 1, animated: false)
    }

    // MARK: - Constraints
    private func activateConstraints(for view: UIView, fillInto superview: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    private func activatePickerLineConstraints() {
        pickerLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerLine.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
            pickerLine.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor),
            pickerLine.heightAnchor.constraint(equalToConstant: 4),
            pickerLine.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
    }

    private func activateTitleConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
}

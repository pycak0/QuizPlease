//
//  TitledTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol TitledTextFieldViewDelegate: AnyObject {
    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String, didCompleteMask isComplete: Bool)
    func textFieldViewDidEndEditing(_ textFieldView: TitledTextFieldView)
}

fileprivate enum Constants {
    static let offset: CGFloat = 14
    static let bottomInset: CGFloat = -8
}

@IBDesignable
class TitledTextFieldView: UIView {
    weak var delegate: TitledTextFieldViewDelegate?
        
    //MARK:- UI
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = .gilroy(.semibold, size: 16)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(.semibold, size: 12)
        label.textColor = .darkGray
        label.contentMode = .left
        label.text = title
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    //MARK:- Inspectables
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
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        addRecognizer()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
    
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
    
    private func addRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func startEditing() {
        guard !textField.isFirstResponder else { return }
        textField.becomeFirstResponder()
    }
    
    //MARK:- Xib Setup
    func setup() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(textField)
        makeConstraints()
    }
    
    func makeConstraints() {
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
}

extension TitledTextFieldView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldViewDidEndEditing(self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldView(self, didChangeTextField: textField.text ?? "", didCompleteMask: true)
    }
}

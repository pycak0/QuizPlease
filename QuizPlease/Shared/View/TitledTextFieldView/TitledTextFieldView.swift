//
//  TitledTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import InputMask

protocol TitledTextFieldViewDelegate: class {
    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String, didCompleteMask isComplete: Bool)
}

//@IBDesignable
class TitledTextFieldView: UIView {
    static let nibName = "TitledTextFieldView"
    
    weak var delegate: TitledTextFieldViewDelegate?
    
    private var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private var listener: MaskedTextFieldDelegate!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        xibSetup()
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateAppearance()
        configure()
    }
    
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
    
    ///Make sure that mask satisfies the syntax described here:
    ///https://github.com/RedMadRobot/input-mask-ios/wiki/1.-Mask-Syntax
    @IBInspectable
    var inputMask: String = "[…]" {
        didSet {
            listener.primaryMaskFormat = inputMask
            //listener.
        }
    }
    
    @IBInspectable
    var titleFontName: String? = "Gilroy-SemiBold" {
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
    var textFontName: String? = "Gilroy-SemiBold" {
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
    
    func updateAppearance() {
        titleLabel.text = title
        textField.placeholder = placeholder
        layer.borderColor = viewBorderColor.cgColor
        layer.borderWidth = viewBorderWidth
        layer.cornerRadius = viewCornerRadius
        layer.masksToBounds = viewCornerRadius > 0
        
        titleLabel.font = titleFontName != nil ? UIFont(name: titleFontName!, size: titleFontSize) : .systemFont(ofSize: titleFontSize, weight: .semibold)
        textField.font = textFontName != nil ? UIFont(name: textFontName!, size: textFontSize) : .systemFont(ofSize: textFontSize, weight: .semibold)
                
    }
    
    //MARK:- Configure
    func configure() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        self.addGestureRecognizer(tapRecognizer)
        if inputMask != listener.primaryMaskFormat {
            listener.primaryMaskFormat = inputMask
        }
    }
    
    @objc
    private func startEditing() {
        guard !textField.isFirstResponder else { return }
        textField.becomeFirstResponder()
    }
    
}

private extension TitledTextFieldView {
    
    //MARK:- Xib Setup
    func xibSetup() {
        let nib = UINib(nibName: TitledTextFieldView.nibName, bundle: nil)
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}


//MARK:- MaskedTextFieldDelegateListener
extension TitledTextFieldView: MaskedTextFieldDelegateListener {
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        //print(value)
        delegate?.textFieldView(self, didChangeTextField: value, didCompleteMask: complete)
    }
}

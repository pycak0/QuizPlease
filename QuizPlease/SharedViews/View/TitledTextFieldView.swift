//
//  TitledTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//@IBDesignable
class TitledTextFieldView: UIView {
    static let nibName = "TitledTextFieldView"
    
    var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
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
    var borderColor: UIColor = .themeGray {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 2 {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 20 {
        didSet {
            updateAppearance()
        }
    }
    
    func updateAppearance() {
        titleLabel.text = title
        textField.placeholder = placeholder
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        
        titleLabel.font = titleFontName != nil ? UIFont(name: titleFontName!, size: titleFontSize) : .systemFont(ofSize: titleFontSize, weight: .semibold)
        textField.font = textFontName != nil ? UIFont(name: textFontName!, size: textFontSize) : .systemFont(ofSize: textFontSize, weight: .semibold)
                
    }
    
    func configure() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        self.addGestureRecognizer(tapRecognizer)
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

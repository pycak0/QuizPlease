//
//  NavigationBar.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol NavigationBarDelegate: class {
    func backButtonPressed(_ sender: Any)
}

class NavigationBar: UIView {
    static let nibName = "NavigationBar"

    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    weak var delegate: NavigationBarDelegate?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    convenience init(title: String?, tintColor: UIColor = .white) {
        self.init()
        titleLabel.text = title
        titleLabel.tintColor = tintColor
        backButton.setTitleColor(tintColor, for: .normal)
    }
    
    @IBAction func backButtonPreseed(_ sender: Any) {
        delegate?.backButtonPressed(sender)
    }
}

private extension NavigationBar {
    
    //MARK:- Xib Setup
    func xibSetup() {
        Bundle.main.loadNibNamed(NavigationBar.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}

//
//  FilterView.swift
//  QuizPlease
//
//  Created by Владислав on 04.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class FilterView: UIView {
    static let nibName = "FilterView"

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var expandImageView: UIImageView!

    public var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }

    private func xibSetup() {
        Bundle.main.loadNibNamed(FilterView.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}

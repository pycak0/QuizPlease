//
//  CopyableLabel.swift
//  QuizPlease
//
//  Created by Владислав on 09.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

public class CopyableLabel: UILabel {

    public override var canBecomeFirstResponder: Bool { true }

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    // MARK: - Actions

    public override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }

    public override func canPerformAction(
        _ action: Selector,
        withSender sender: Any?
    ) -> Bool {
        action == #selector(copy(_:))
    }

    // MARK: - Private Methods

    private func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(showMenu)
        ))
    }

    @objc private func showMenu() {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        let offsetX = -bounds.width / 2
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds.offsetBy(dx: offsetX, dy: 0), in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
}

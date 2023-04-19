//
//  TestViewController.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 19.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

final class TestViewController: UIViewController {

    private let titledTextView: TitledTextView = {
        let titledTextView = TitledTextView()
        titledTextView.translatesAutoresizingMaskIntoConstraints = false
        return titledTextView
    }()

    private let titledTextFieldView: TitledTextFieldView = {
        let titledTextFieldView = TitledTextFieldView()
        titledTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        return titledTextFieldView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackgroundAdapted
        view.addSubview(titledTextView)
        view.addSubview(titledTextFieldView)
        NSLayoutConstraint.activate([
            titledTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titledTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titledTextView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
//            titledTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),

            titledTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titledTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titledTextFieldView.bottomAnchor.constraint(equalTo: titledTextView.topAnchor, constant: -30)
        ])
    }
}

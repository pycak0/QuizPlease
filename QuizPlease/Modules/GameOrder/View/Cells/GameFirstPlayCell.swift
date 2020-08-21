//
//  GameFirstPlayCell.swift
//  QuizPlease
//
//  Created by Владислав on 22.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class GameFirstPlayCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GameFirstPlayCell"
    
    @IBOutlet private weak var checkBoxImageView: UIImageView!
    @IBOutlet private weak var checkBoxStack: UIStackView!
    
    var isPlayingFirstTime: Bool! {
        didSet {
            checkBoxImageView.image = isPlayingFirstTime ? UIImage(named: "rectDot") : nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        isPlayingFirstTime = false
        checkBoxStack.addTapGestureRecognizer {
            self.isPlayingFirstTime.toggle()
        }
    }
    
}

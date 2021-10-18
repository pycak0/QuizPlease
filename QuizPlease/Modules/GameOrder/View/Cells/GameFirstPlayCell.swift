//
//  GameFirstPlayCell.swift
//  QuizPlease
//
//  Created by Владислав on 22.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameFirstPlayCellDelegate: AnyObject {
    func firstPlayCell(_ cell: GameFirstPlayCell, didChangeStateTo isFirstPlay: Bool)
}

class GameFirstPlayCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameFirstPlayCell"
    
    @IBOutlet private weak var checkBoxImageView: UIImageView!
    @IBOutlet private weak var checkBoxStack: UIStackView!
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameFirstPlayCellDelegate }
    }
    private weak var _delegate: GameFirstPlayCellDelegate?
    
    var isPlayingFirstTime: Bool! {
        didSet {
            checkBoxImageView.image = isPlayingFirstTime ? UIImage(named: "rectDot") : nil
            _delegate?.firstPlayCell(self, didChangeStateTo: isPlayingFirstTime)
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

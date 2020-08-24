//
//  GameGeneralDescriptionCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameDescriptionDelegate: class {
    func optionalDescription(for descriptionCell: GameGeneralDescriptionCell) -> String?
}

extension GameDescriptionDelegate {
    func optionalDescription(for descriptionCell: GameGeneralDescriptionCell) -> String? {
        return nil
    }
}

class GameGeneralDescriptionCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameGeneralDescriptionCell"
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameDescriptionDelegate }
    }
    private weak var _delegate: GameDescriptionDelegate? {
        didSet {
            if let text = _delegate?.optionalDescription(for: self) {
                descriptionLabel.text = text
            }
        }
    }
    
}

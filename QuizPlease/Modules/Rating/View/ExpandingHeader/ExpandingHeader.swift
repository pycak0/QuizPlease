//
//MARK:  ExpandingHeader.swift
//  ExpandingTableViewHeader
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Selected Segment
enum EHSelectedSegment: Int, CaseIterable {
    case allTime, season
    
    var title: String {
        switch self {
        case .allTime:
            return "За все время"
        case .season:
            return "За сезон"
        }
    }
}

//MARK:- Delegate Protocol
protocol ExpandingHeaderDelegate: class {
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChangeStateTo isExpanded: Bool)
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange selectedSegment: EHSelectedSegment)
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange query: String)
    
    //func expandingHeader(_ expandingHeader: ExpandingHeader, didEndSearchingWith query: String)
    
}


class ExpandingHeader: UIView {
    static let nibName = "ExpandingHeader"
    let collapsedHeight: CGFloat = 140
    let expandedHeight: CGFloat = 320
    lazy var gradientExpandedHeight: CGFloat = expandedHeight - 65
    
    weak var delegate: ExpandingHeaderDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var expandView: UIView!
    @IBOutlet weak var footLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var segmentControl: HBSegmentedControl!
    @IBOutlet weak var gameTypesView: UIView!
    @IBOutlet weak var collapseButton: UIButton!
    
    unowned var gradientLayer: CAGradientLayer!
    
    //MARK:- is Expanded
    public var isExpanded = false {
        didSet { setExpanded(isExpanded) }
    }
    
    @IBAction func collapseButtonPressed(_ sender: Any) {
        isExpanded = false
    }
    
    @objc
    func toggleExpanded() {
        isExpanded.toggle()
        //setExpanded(isExpanded)
    }
    
    //MARK:- Set Expanded
    func setExpanded(_ isExpanded: Bool) {
        if !isExpanded { endEditing(true) }
        
        let height: CGFloat = isExpanded ? expandedHeight : collapsedHeight
        let grHeight: CGFloat = isExpanded ? gradientExpandedHeight : collapsedHeight

        let alpha: CGFloat = isExpanded ? 0 : 1
        let opacity: Float = isExpanded ? 1 : 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .layoutSubviews, animations: {
            //self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
            self.frame.setHeight(height)
            self.gradientLayer.frame.setHeight(grHeight)
            
            self.gradientLayer.opacity = opacity
            self.setItemsHidden(!isExpanded)
            //self.labels.forEach { $0.isHidden = !self.expanded }
            self.expandView.isHidden = isExpanded
            self.expandView.alpha = alpha
            self.layoutIfNeeded()
            
            self.delegate?.expandingHeader(self, didChangeStateTo: isExpanded)
        }, completion: nil)
    }
    
    private func setItemsHidden(_ isHidden: Bool) {
        let number = stackView.arrangedSubviews.count - 1
        for i in 1...number {
            stackView.arrangedSubviews[i].isHidden = isHidden
            stackView.arrangedSubviews[i].alpha = isHidden ? 0 : 1
        }
    }
    
    //MARK:- Segment Changed
    @objc
    private func segmentChanged() {
        guard let selectedSegment = EHSelectedSegment(rawValue: segmentControl.selectedIndex) else { return }
        delegate?.expandingHeader(self, didChange: selectedSegment)
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    func xibSetup() {
        Bundle.main.loadNibNamed(ExpandingHeader.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    //MARK:- Awake from Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
        setExpanded(isExpanded)
    }
    
    func configureViews() {
        let itemsCornerRadius: CGFloat = 20
        let color = UIColor.plum.withAlphaComponent(0.5)
        
        expandView.layer.cornerRadius = itemsCornerRadius
        expandView.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(toggleExpanded)))
        collapseButton.tintColor = color
        
        configureSearchField(radius: itemsCornerRadius, color: color)
        configureSegmentControl(color: color)        
        
        gameTypesView.layer.cornerRadius = itemsCornerRadius
        gameTypesView.backgroundColor = color
        
        setupGradient()
    }
    
    private func setupGradient() {
        let origin = self.frame.origin
        let size = CGSize(width: UIScreen.main.bounds.width, height: gradientExpandedHeight)
        self.addGradient(colors: [.systemBlue, .systemPurple],
                         frame: CGRect(origin: origin, size: size),
                         insertAt: 0)
        gradientLayer = self.layer.sublayers?.first as? CAGradientLayer
    }
    
    private func configureSearchField(radius: CGFloat, color: UIColor) {
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchField.layer.cornerRadius = radius
        searchField.backgroundColor = color
        searchField.setImage(UIImage(named: "search"))
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                NSAttributedString.Key.font : UIFont(name: "Gilroy-Bold", size: 16)!,
                NSAttributedString.Key.foregroundColor : UIColor.white
        ])
    }
    
    private func configureSegmentControl(color: UIColor) {
        segmentControl.items = ["За все время", "За сезон"]
        segmentControl.selectedIndex = 1
        segmentControl.dampingRatio = 0.7
        segmentControl.font = UIFont(name: "Gilroy-Bold", size: 16)
        segmentControl.backgroundColor = color
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
}

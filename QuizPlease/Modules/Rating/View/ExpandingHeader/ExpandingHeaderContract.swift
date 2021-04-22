//
//  ExpandingHeaderContract.swift
//  QuizPlease
//
//  Created by Владислав on 22.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

public protocol ExpandingHeaderDelegate: class {
    ///Delegate should provide a new selected Game Type Name string as an argument for `completion` closure for the `ExpandingHeader` to update its `selectedGameTypeLabel` text
    func didPressGameTypeView(in expandingHeader: ExpandingHeader, completion: @escaping (_ selectedName: String?) -> Void)
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChangeStateTo isExpanded: Bool)
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange selectedSegment: Int)
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange query: String)
    
    ///Is called when `ExpandingHeader`'s `searchField` did end editing
    func expandingHeader(_ expandingHeader: ExpandingHeader, didEndSearchingWith query: String)
    
    ///Is called when `ExpandingHeader`'s `searchField` did press return button
    func expandingHeader(_ expandingHeader: ExpandingHeader, didPressReturnButtonWith query: String)
}

public protocol ExpandingHeaderDataSource: class {
    func numberOfSegmentControlItems(in expandingHeader: ExpandingHeader) -> Int
    
    func expandingHeaderSelectedSegmentIndex(_ expandingHeader: ExpandingHeader) -> Int
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, titleForSegmentAtIndex segmentIndex: Int) -> String
    
    func expandingHeaderInitialSelectedGameType(_ expandingHeader: ExpandingHeader) -> String
}

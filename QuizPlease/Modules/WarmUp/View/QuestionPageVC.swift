//
//  QuestionPageVC.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class QuestionPageVC: UIPageViewController {
    
    private var _viewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(with items: [WarmupQuestion], delegate: WarmupQuestionVCAnswerDelegate?) {
        dataSource = self
        
        items.forEach {
            let vc = WarmupQuestionVC($0)
            vc.delegate = delegate
            self._viewControllers.append(vc)
        }
    }
    
    func start() {
        guard let vc = _viewControllers.first else { return }
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func next() {
        guard _viewControllers.count > 1 else { return }
        setViewControllers([_viewControllers[1]], direction: .forward, animated: true, completion: nil)
        _viewControllers.removeFirst()
    }

}

extension QuestionPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}

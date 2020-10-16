//
//  QuestionPageVC.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol QuestionPageVCDelegate: class {
    func questionsDidEnd()
}

class QuestionPageVC: UIPageViewController {
    
    private var _viewControllers = [UIViewController]()
    
    private weak var questionsDelegate: QuestionPageVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(with items: [WarmupQuestion], delegate: (QuestionPageVCDelegate & WarmupQuestionVCAnswerDelegate)?) {
        dataSource = self
        
        items.forEach {
            let vc = WarmupQuestionVC($0)
            vc.delegate = delegate
            _viewControllers.append(vc)
        }
        questionsDelegate = delegate
    }
    
    func start() {
        guard let vc = _viewControllers.first else { return }
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func next() {
        guard _viewControllers.count > 1 else {
            questionsDelegate?.questionsDidEnd()
            return
        }
        isPagingEnabled = false
        setViewControllers([_viewControllers[1]], direction: .forward, animated: true) { _ in
            self.isPagingEnabled = true
        }
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

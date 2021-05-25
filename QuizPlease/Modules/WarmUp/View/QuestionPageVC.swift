//
//  QuestionPageVC.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol QuestionPageVCDelegate: AnyObject {
    func questionsDidEnd()
}

class QuestionPageVC: UIPageViewController {
    
    private var _viewControllers = [UIViewController]()
    private weak var questionsDelegate: QuestionPageVCDelegate?
    
    var currentViewController: WarmupQuestionVC? {
        viewControllers?.first as? WarmupQuestionVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(with items: [WarmupQuestion], delegate: (QuestionPageVCDelegate & WarmupQuestionVCAnswerDelegate)?) {
        dataSource = self
        
        items.forEach { question in
            let vc = WarmupQuestionVC(question)
            vc.delegate = delegate
            _viewControllers.append(vc)
        }
        questionsDelegate = delegate
    }
    
    func start() {
        let vc = _viewControllers.removeFirst()
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func next() {
        guard !_viewControllers.isEmpty else {
            questionsDelegate?.questionsDidEnd()
            return
        }
        isPagingEnabled = false
        setViewControllers([_viewControllers.removeFirst()], direction: .forward, animated: true) { _ in
            self.isPagingEnabled = true
        }
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

//
//  QuestionPageVC.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

/// QuestionPageVC delegate protocol.
protocol QuestionPageVCDelegate: AnyObject {

    /// Tells the delegate that questions are over.
    func questionsDidEnd()
}

final class QuestionPageVC: UIPageViewController {

    private var _viewControllers = [UIViewController]()
    private weak var questionsDelegate: QuestionPageVCDelegate?

    var currentViewController: WarmupQuestionVC? {
        viewControllers?.first as? WarmupQuestionVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isPagingEnabled = false
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
        next()
    }

    func next() {
        guard !_viewControllers.isEmpty else {
            questionsDelegate?.questionsDidEnd()
            return
        }
        isPagingEnabled = false
        let nextViewController = _viewControllers.removeFirst()
        setViewControllers([nextViewController], direction: .forward, animated: true)
    }
}

extension QuestionPageVC: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }
}

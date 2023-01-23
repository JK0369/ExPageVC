//
//  ViewController.swift
//  ExPageVC
//
//  Created by 김종권 on 2023/01/23.
//

import UIKit

class ViewController: UIViewController {
    private let pageVC: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        return pageVC
    }()
    
    private var items = (0...2).map(String.init)
    fileprivate var contentViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewControllers()
        
        setUpViews()
        
        setUpLayout()
    }
    
    private func setUpViewControllers() {
        items
            .forEach { title in
                let vc = LabelViewController() // 단순히 UILabel을 가지고 있는 VC
                vc.titleText = title
                contentViewControllers.append(vc)
            }
    }
    
    private func setUpViews() {
        pageVC.dataSource = self
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        pageVC.setViewControllers([contentViewControllers[0]], direction: .forward, animated: false)
        
        // 1.
        let scrollView = pageVC.view.subviews
            .compactMap { $0 as? UIScrollView }
            .first

        scrollView?.delegate = self
    }
    
    private func setUpLayout() {
        view.addSubview(pageVC.view)
        
        NSLayoutConstraint.activate([
            pageVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageVC.view.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
}

extension ViewController: UIPageViewControllerDataSource {
    // left -> right 스와이프 하기 직전 호출 (다음 화면은 무엇인지 리턴)
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = contentViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        return contentViewControllers[previousIndex]
    }
    
    // right -> left 스와이프 하기 직전 호출 (이전 화면은 무엇인지 리턴)
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = contentViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < contentViewControllers.count else { return nil }
        return contentViewControllers[nextIndex]
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 2.
        print(scrollView.bounces, scrollView.contentOffset)
        
        let currentPageIndex = contentViewControllers
            .enumerated()
            .first(where: { _, vc in vc == pageVC.viewControllers?.first })
            .map(\.0) ?? 0
        
        let isFirstable = currentPageIndex == 0
        let isLastable = currentPageIndex == contentViewControllers.count - 1
        let shouldDisableBounces = isFirstable || isLastable
        scrollView.bounces = !shouldDisableBounces
    }
}

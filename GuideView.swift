//
//  GuideView.swift
//  GuideViewDemo
//
//  Created by LiYuechang on 16/6/30.
//  Copyright © 2016年 LiYuechang. All rights reserved.
//

import UIKit

class GuideView: UIView {
    private var pageViews: [UIView] = []
    private var pageControl: UIPageControl?
    private var enterButton: UIButton?
    private var scrollView: UIScrollView?
    var swipeToExit = true
    
// MARK: initialize with frame and pages
    init(frame: CGRect, pages: [UIView]) {
        super.init(frame: frame)
        
        if pages.count > 0 {
            pageViews = pages
            setupScrollView()
            setupEnterButton()
            setupPageControl()
        }
    }
    
// MARK: set up scrollView
    private func setupScrollView() {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: CGFloat(pageViews.count) * self.bounds.width, height: self.bounds.height)
        
        for (index, page) in pageViews.enumerated() {
            var rect = page.frame;
            rect.origin.x = self.bounds.width * CGFloat(index)
            page.frame = rect
            scrollView.addSubview(page)
        }
        self.addSubview(scrollView)
        self.scrollView = scrollView
    }
    
// MARK: set up enterButton
    private func setupEnterButton() {
        let enterButton = UIButton(frame: CGRect(x: self.bounds.width/2 - 60, y: self.bounds.height - 100, width: 120, height: 40))
        enterButton.layer.cornerRadius = 5.0
        enterButton.backgroundColor = UIColor.darkGray()
        enterButton.setTitle("立即体验", for: UIControlState())
        enterButton.addTarget(self, action: #selector(GuideView.hide), for: .touchUpInside)
        enterButton.isHidden = true
        self.addSubview(enterButton)
        self.enterButton = enterButton
    }
    
// MARK: set up pageControl
    private func setupPageControl() {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.height - 150, width: self.bounds.width, height: 20))
        pageControl.numberOfPages = pageViews.count
        pageControl.currentPageIndicatorTintColor = UIColor.gray()
        self.addSubview(pageControl)
        self.pageControl = pageControl
    }
    
// MARK: show in window
    func showWithAnimationDuration(_ duration: TimeInterval) {
        self.alpha = 0
        var view: UIView?
        let windows = UIApplication.shared().windows
        
        for window in windows {
            let windowInMainScreen = window.screen == UIScreen.main()
            let windowIsVisible = !window.isHidden && window.alpha > 0
            let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
            
            if windowInMainScreen && windowIsVisible && windowLevelNormal {
                view = window
                break
            }
        }
        
        
        if self.superview != view {
            view!.addSubview(self)
        } else {
            view!.bringSubview(toFront: self)
        }
        
        UIView.animate(withDuration: duration) { 
           self.alpha = 1
        }
    }

// MARK: disappear
    func hide() {
        UIView .animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIScrollViewDelegate
extension GuideView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width/2) / self.bounds.width)
        
        UIView.animate(withDuration: 0.5) {
            if index == self.pageViews.count - 1 {
                self.enterButton!.isHidden = false
                self.pageControl!.currentPage = index
            }else if index == self.pageViews.count && self.swipeToExit {
                self.removeFromSuperview()
            } else {
                self.enterButton!.isHidden = true
                self.pageControl!.currentPage = index
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.bounds.width)
        
        if index == pageViews.count - 1  && swipeToExit {
            self.alpha = (CGFloat(pageViews.count) * self.bounds.width - scrollView.contentOffset.x)/self.bounds.width
        }
    }
}





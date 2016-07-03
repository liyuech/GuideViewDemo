//
//  ViewController.swift
//  GuideViewDemo
//
//  Created by LiYuechang on 16/6/30.
//  Copyright © 2016年 LiYuechang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if needShowGuideView() {
            DispatchQueue.main.after(when: DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                self.showGuideView()
            }
        }
    }
    
    private func showGuideView() {
        let guideView = GuideView(frame: view.bounds, pages: getGuidePages())
        guideView.showWithAnimationDuration(0.5)
    }
    
    private func getGuidePages() -> [UIView] {
        var guidePages: [UIView] = []
        
        for i in 0...2 {
            let imageName = String("guide_\(i)")
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(named: imageName)
            guidePages.append(imageView)
        }
        
        return guidePages
    }
    
    private func needShowGuideView() -> Bool {
        // version judge
        
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
}

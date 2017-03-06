//
//  DriftingViewController.swift
//  Rock Box
//
//  Created by Vega on 2016/11/12.
//  Copyright © 2016年 Jia Wei. All rights reserved.
//

import UIKit
import CoreMotion

class DriftingViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 160, y: 80, width: 100, height: 100))
        imageView.image = #imageLiteral(resourceName: "lemur.png")
        self.view.addSubview(imageView)
        return imageView
    }()
    
    var scale: CGFloat = 30
    let motionQueue = OperationQueue()
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        startDrifting(imageView)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func startDrifting(_ imageView: UIImageView) {
        motionManager.startAccelerometerUpdates(to: motionQueue) {
            data, error in
            DispatchQueue.main.sync {
                var imageFrame = imageView.frame
                imageFrame.origin.x = imageFrame.origin.x + CGFloat(data!.acceleration.x) * self.scale
                if !self.view.bounds.contains(imageFrame) { imageFrame.origin.x = imageView.frame.origin.x }
                imageFrame.origin.y = imageFrame.origin.y - CGFloat(data!.acceleration.x) * self.scale
                if !self.view.bounds.contains(imageFrame) { imageFrame.origin.y = imageView.frame.origin.y }
                imageView.frame = imageFrame
            }
        }
    }
    
    func tap(gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState], animations: {
            self.imageView.center = gesture.location(in: self.view)
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState], animations: {
            self.imageView.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        }, completion: {
            finished in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState], animations: {
                self.imageView.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }

}

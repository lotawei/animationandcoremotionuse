//
//  MotionViewController.swift
//  Rock Box
//
//  Created by Vega on 2016/11/13.
//  Copyright © 2016年 Jia Wei. All rights reserved.
//

import UIKit
import CoreMotion

class MotionViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 160, y: 80, width: 100, height: 100))
        imageView.image = #imageLiteral(resourceName: "lemur.png")
        self.view.addSubview(imageView)
        return imageView
    }()
    
    var scale: CGFloat = 30
    let gravity = UIGravityBehavior()
    let motionQueue = OperationQueue()
    let collider = UICollisionBehavior()
    let manager = CMMotionManager()
    var animator:UIDynamicAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        gravity.addItem(imageView)
        collider.addItem(imageView)
        createAnimatorStuff()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.stopDeviceMotionUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let queue = OperationQueue()
        manager.startDeviceMotionUpdates(to: queue) { (motion, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            let motionGravity: CMAcceleration = motion!.gravity
            var point = CGPoint(x: motionGravity.x, y: motionGravity.y)
            
            let orientation = UIApplication.shared.statusBarOrientation
            if orientation == .landscapeLeft {
                let t = point.x
                point.x = 0 - point.y
                point.y = t
            } else if orientation == .landscapeRight {
                let t = point.x
                point.x = point.y
                point.y = 0 - t
            } else if orientation == .portraitUpsideDown {
                point.x *= -1
                point.y *= -1
            }
            self.gravity.gravityDirection = CGVector(dx: motionGravity.x, dy: 0 - motionGravity.y)
        }
        
    }
    
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view)
        
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
        animator?.addBehavior(gravity)
        
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
    }
    
}

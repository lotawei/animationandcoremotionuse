//
//  ViewController.swift
//  CoreMotionDemo
//
//  Created by Vega on 2016/11/12.
//  Copyright © 2016年 Jia Wei. All rights reserved.
//

import UIKit


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 0.5)
    }
}

class BoxViewController: UIViewController {
    
    var box: UIView?
    var animator:UIDynamicAnimator?
    
    func createAnimatorStuff() {
        let collision = UICollisionBehavior()
        collision.addItem(box!)
        collision.translatesReferenceBoundsIntoBoundary = true
        
        let gravity = UIGravityBehavior()
        gravity.addItem(box!)
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
        
        animator = UIDynamicAnimator(referenceView:self.view)
        animator?.addBehavior(gravity)
        animator?.addBehavior(collision)
    }
    
    func addBox(at rect: CGRect) {
        let newBox = UIView(frame: rect)
        newBox.backgroundColor = UIColor.randomColor()
        view.insertSubview(newBox, at: 0)
        box = newBox
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addBox(at: CGRect(x: 100, y: 100, width: 30, height: 30))
        createAnimatorStuff()
    }
    
    
}

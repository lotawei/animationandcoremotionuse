//
//  StarbucksViewController.swift
//  Rock Box
//
//  Created by Vega on 2016/11/13.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

import UIKit
import CoreMotion

class StarbucksViewController: UIViewController {
    
    var maxX : CGFloat!
    var maxY : CGFloat!
    let boxSize : CGFloat = 30.0
    var boxes : Array<UIView> = []
    
    var animator:UIDynamicAnimator?
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    let manager = CMMotionManager()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        maxX = view.bounds.size.width - boxSize
        maxY = view.bounds.size.height - boxSize
        
        createAnimatorStuff()
        generateBoxes()
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
    
    // MARK: - generator
    
    func generateBoxes() {
        
        func addBoxToBehaviors(box: UIView) {
            gravity.addItem(box)
            collider.addItem(box)
        }
        
        func addBox(location: CGRect, color: UIColor) {
            let newBox = UIView(frame: location)
            newBox.backgroundColor = color
            
            view.addSubview(newBox)
            addBoxToBehaviors(box: newBox)
            boxes.append(newBox)
        }
        
        for _ in 0...80 {
            addBox(location: randomFrame(), color: randomColor())
        }
    }
    
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view)
        
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
        animator?.addBehavior(gravity)
        
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
    }
    
    // MARK: - helpers
    
    func randomColor() -> UIColor {
        let red = CGFloat(CGFloat(arc4random()%100000)/100000)
        let green = CGFloat(CGFloat(arc4random()%100000)/100000)
        let blue = CGFloat(CGFloat(arc4random()%100000)/100000)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 0.85)
    }
    
    func randomFrame() -> CGRect {
        var guess = CGRect(x: 9, y: 9, width: 9, height: 9)
        
        repeat {
            let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: maxX)
            let y = CGFloat(arc4random()).truncatingRemainder(dividingBy: maxY)
            guess = CGRect(x: x, y: y, width: boxSize, height: boxSize)
        } while(!doesNotCollide(testRect: guess))
        
        return guess
    }
    
    func doesNotCollide(testRect: CGRect) -> Bool {
        for box : UIView in boxes {
            if(testRect.intersects(box.frame)) {
                return false
            }
        }
        return true
    }
    
}



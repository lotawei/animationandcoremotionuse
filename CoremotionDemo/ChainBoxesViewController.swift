//
//  ChainBoxesViewController.swift
//  Rock Box
//
//  Created by Vega on 2016/11/12.
//  Copyright © 2016年 Jia Wei. All rights reserved.
//

import UIKit
import CoreMotion

class ChainBoxesViewController: UIViewController {
    
    var maxX: CGFloat = 320
    var maxY: CGFloat = 320
    let boxSize: CGFloat = 30.0
    var boxes: Array<UIView> = []
    
    let motionQueue = OperationQueue()
    let motionManager = CMMotionManager()
    
    var animator:UIDynamicAnimator? = nil
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    let itemBehavior = UIDynamicItemBehavior()
    
    let startPoint = CGPoint(x: 50, y: 50)
    var prevBox = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        maxX = super.view.bounds.size.width - boxSize
        maxY = super.view.bounds.size.height - boxSize
        createAnimatorStuff()
        generateBoxes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Starting gravity")
        motionManager.startDeviceMotionUpdates(to: motionQueue) {
            (motion, error) in
            let grav : CMAcceleration = motion!.gravity
            
            let x = CGFloat(grav.x)
            let y = CGFloat(grav.y)
            var p = CGPoint(x: x,y: y)
            
            if let error = error {
                print(error)
            }
            
            let orientation = UIApplication.shared.statusBarOrientation
            
            if(orientation == UIInterfaceOrientation.landscapeLeft) {
                let t = p.x
                p.x = 0 - p.y
                p.y = t
            } else if (orientation == UIInterfaceOrientation.landscapeRight) {
                let t = p.x
                p.x = p.y
                p.y = 0 - t
            } else if (orientation == UIInterfaceOrientation.portraitUpsideDown) {
                p.x *= -1
                p.y *= -1
            }
            
            let v = CGVector(dx: p.x, dy: 0 - p.y)
            self.gravity.gravityDirection = v
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)  {
        super.viewDidDisappear(animated)
        NSLog("Stopping gravity")
        motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - helpers
    
    func randomColor() -> UIColor {
        let red = CGFloat(CGFloat(arc4random()%100000)/100000)
        let green = CGFloat(CGFloat(arc4random()%100000)/100000)
        let blue = CGFloat(CGFloat(arc4random()%100000)/100000)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 0.85)
    }
    
    func doesNotCollide(_ testRect: CGRect) -> Bool {
        for box : UIView in boxes {
            let viewRect = box.frame
            if(testRect.intersects(viewRect)) {
                return false
            }
        }
        return true
    }
    
    func randomFrame() -> CGRect {
        var guess = CGRect(x: 9, y: 9, width: 9, height: 9)
        
        repeat {
            let guessX = CGFloat(arc4random()).truncatingRemainder(dividingBy: maxX)
            let guessY = CGFloat(arc4random()).truncatingRemainder(dividingBy: maxY)
            guess = CGRect(x: guessX, y: guessY, width: boxSize, height: boxSize)
        } while(!doesNotCollide(guess))
        
        return guess
    }
    
    func generateBoxes() {
        
        func addBoxToBehaviors(_ box: UIView) {
            gravity.addItem(box)
            collider.addItem(box)
            itemBehavior.addItem(box)
        }
        
        func addBox(_ location: CGRect, color: UIColor) -> UIView {
            let newBox = UIView(frame: location)
            newBox.backgroundColor = color
            
            view.addSubview(newBox)
            addBoxToBehaviors(newBox)
            boxes.append(newBox)
            return newBox
        }
        
        func chainBoxes(_ box: UIView) {
            if(prevBox.frame.origin.x == 0) {
                let attach = UIAttachmentBehavior(item:box, attachedToAnchor:startPoint)
                attach.length = 61
                attach.damping = 0.5
                animator?.addBehavior(attach)
                prevBox = box
            } else {
                let attach = UIAttachmentBehavior(item:box, attachedTo:prevBox)
                attach.length = 61
                attach.damping = 0.5
                animator?.addBehavior(attach)
                prevBox = box
            }
        }
        
        for _ in 0..<80 {
            let newBox = addBox(randomFrame(), color: randomColor())
            chainBoxes(newBox)
        }
    }
    
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view)
        
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
        animator?.addBehavior(gravity)
        
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        itemBehavior.friction = 0.1
        itemBehavior.elasticity = 0.9
        animator?.addBehavior(itemBehavior)
    }
    
}


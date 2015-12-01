//
//  ViewController.swift
//  Project 6
//
//  Created by Bernard JIANG on 5/11/15.
//  Copyright © 2015 Bernard JIANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var gameOverScreen: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var spaceshipImage: UIImageView!
    @IBOutlet weak var finalScore: UILabel!
    
    var score: Int = 0
    var animator: UIDynamicAnimator!
    var timer: NSTimer!
    var interval: Double!
    let gravity = UIGravityBehavior()
    let collision = UICollisionBehavior()
    let missileBehavior = UIPushBehavior()
    var asteroid: UIImageView!
    var missile: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        gameOverScreen.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "createAsteroid:", userInfo: nil, repeats: true)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity.magnitude = 0.5
        animator.addBehavior(gravity)
        
        missileBehavior.pushDirection = CGVector(dx: 0, dy: -1)
        animator.addBehavior(missileBehavior)
        
        collision.addItem(spaceshipImage)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAsteroid(sender: NSTimer) {

        let size = randomSize()
        let randomCoord = CGFloat(arc4random()) % (view.frame.width - (size * 2)) + size
        
        asteroid = UIImageView(frame: CGRect(x: randomCoord, y: 1, width: size, height: size))
        asteroid.image = UIImage(named: "asteroid")
        asteroid.tag = 1
        view.insertSubview(asteroid, belowSubview: topBarView)
        
        gravity.addItem(asteroid)
        collision.addItem(asteroid)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        let object = item as! UIImageView
        
        if object.tag == 1 {
            object.removeFromSuperview()
            collision.removeItem(item)
            gravity.removeItem(item)
            scoreLabel.text = "\(score + 10)"
            score += 10
        }
        
        if object.tag == 2 {
            object.removeFromSuperview()
            collision.removeItem(item)
            missileBehavior.removeItem(item)
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        let itemOne = item1 as! UIImageView
        let itemTwo = item2 as! UIImageView
        
        if itemOne.tag == 1 && itemTwo.tag == 3 {
            itemOne.removeFromSuperview()
            collision.removeItem(item1)
            collision.removeItem(item2)
            gravity.removeItem(item1)
            itemTwo.image = UIImage(named: "explosion")
            
            for labels in topBarView.subviews {
                labels.hidden = true
            }
            
            finalScore.text = scoreLabel.text
            UIView.animateWithDuration(2.0, delay: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: {self.gameOverScreen.alpha = 0.5}, completion: nil)
            UIView.animateWithDuration(3.0, delay: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: {self.spaceshipImage.alpha = 0}, completion: {
                (finished: Bool) -> Void in
                self.gravity.removeItem(item2)
                itemTwo.removeFromSuperview()})
            
        } else if itemTwo.tag == 1 && itemOne.tag == 3 {
            itemTwo.removeFromSuperview()
            collision.removeItem(item2)
            collision.removeItem(item1)
            gravity.removeItem(item2)
            itemOne.image = UIImage(named: "explosion")
            
            for labels in topBarView.subviews {
                labels.hidden = true
            }
            
            finalScore.text = scoreLabel.text
            UIView.animateWithDuration(2.0, delay: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: {self.gameOverScreen.alpha = 0.5}, completion: nil)
            UIView.animateWithDuration(3.0, delay: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: {self.spaceshipImage.alpha = 0}, completion: {(finished: Bool) -> Void in
                self.gravity.removeItem(item1)
                itemOne.removeFromSuperview()})
        }
        
        if itemOne.tag == 1 && itemTwo.tag == 2 {
            itemOne.removeFromSuperview()
            itemTwo.removeFromSuperview()
            collision.removeItem(item2)
            collision.removeItem(item1)
            gravity.removeItem(item1)
            missileBehavior.removeItem(item2)
            scoreLabel.text = "\(score + 10)"
            score += 10
        } else if itemOne.tag == 2 && itemTwo.tag == 1 {
            itemOne.removeFromSuperview()
            itemTwo.removeFromSuperview()
            collision.removeItem(item2)
            collision.removeItem(item1)
            gravity.removeItem(item2)
            missileBehavior.removeItem(item1)
            scoreLabel.text = "\(score + 10)"
            score += 10
        }
    }
    
    @IBAction func moveSpaceship(sender: UIPanGestureRecognizer) {
        let shipImage = sender.view!
        let trans = sender.translationInView(view)
        shipImage.center = CGPoint(x: shipImage.center.x + trans.x, y: shipImage.center.y + trans.y)
        
        sender.setTranslation(CGPointZero, inView: view)
        animator.updateItemUsingCurrentState(shipImage)
    }
    
    @IBAction func shootMissile(sender: UITapGestureRecognizer) {
        let shipImage = sender.view!
        missile = UIImageView(frame: CGRect(x: CGFloat(shipImage.center.x), y: CGFloat(shipImage.frame.minY - 65), width: 15, height: 45))
        missile.image = UIImage(named: "missile")
        missile.tag = 2
        view.addSubview(missile)
        
        missileBehavior.addItem(missile)
        collision.addItem(missile)
    }

    @IBAction func mainMenuPressed(sender: UIButton) {
    }
    
    func randomSize() -> CGFloat {
        let random = Float(arc4random()) % 40.0 + 20.0
        return CGFloat(random)
    }
}


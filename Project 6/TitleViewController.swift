//
//  TitleViewController.swift
//  Project 6
//
//  Created by Bernard JIANG on 6/11/15.
//  Copyright © 2015 Bernard JIANG. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var difficultySelector: UISegmentedControl!
    
    var animator: UIDynamicAnimator!
    var timer: NSTimer!
    var interval: Double = 1
    let gravity = UIGravityBehavior()
    let collision = UICollisionBehavior()
    var asteroid: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "createAsteroid:", userInfo: nil, repeats: true)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity.magnitude = 0.5
        animator.addBehavior(gravity)
        
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
    }
    
    func createAsteroid(sender: NSTimer) {
        
        let size = randomSize()
        let randomCoord = CGFloat(arc4random()) % (view.frame.width - (size * 2)) + size
        
        asteroid = UIImageView(frame: CGRect(x: randomCoord, y: 20, width: size, height: size))
        asteroid.image = UIImage(named: "asteroid")
        asteroid.tag = 1
        view.insertSubview(asteroid, belowSubview: titleImage)
        
        gravity.addItem(asteroid)
        collision.addItem(asteroid)
    }
    
    @IBAction func difficultySelected(sender: UISegmentedControl) {
        
        switch difficultySelector.selectedSegmentIndex {
        case 0:
            interval = 1.0
        case 1:
            interval = 0.5
        case 2:
            interval = 0.35
        case 3:
            interval = 0.25
        default:
            break
        }
        
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "createAsteroid:", userInfo: nil, repeats: true)
    }
    
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        let asteroidImage = item as! UIImageView
        
        if asteroidImage.tag == 1 {
            asteroidImage.removeFromSuperview()
            collision.removeItem(item)
            gravity.removeItem(item)
        }
    }
    
    func randomSize() -> CGFloat {
        let random = Float(arc4random()) % 40.0 + 20.0
        return CGFloat(random)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startGame" {
            let destination = segue.destinationViewController as! ViewController
            
            destination.interval = self.interval
            timer.invalidate()
        }
        
    }

}

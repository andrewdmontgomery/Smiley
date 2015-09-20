//
//  CanvasViewController.swift
//  Smiley
//
//  Created by Andrew Montgomery on 9/19/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    private var trayOriginalCenter: CGPoint!
    private var trayOpenPosition: CGPoint!
    private var trayClosedPosition: CGPoint!
    private var newlyCreatedFace: UIImageView!
    private var faceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayOpenPosition = CGPoint(x: 160.0, y: 458.0)
        trayClosedPosition = CGPoint(x: 160.0, y: 650.0)
        
        trayView.center = trayOpenPosition
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func onFacePan(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(view)
        let translation = panGestureRecognizer.translationInView(view)
        let faceView = panGestureRecognizer.view
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            faceOriginalCenter = faceView?.center
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                faceView?.transform = CGAffineTransformMakeScale(1.2, 1.2)
            })
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            faceView?.center = CGPoint(x: faceOriginalCenter.x + translation.x, y: faceOriginalCenter.y + translation.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                faceView?.transform = CGAffineTransformIdentity
            })
        }

    }
    
    func onFacePinch(sender: UIPinchGestureRecognizer) {
        let pinchGestureRecognizer = sender
        
        if let faceView = pinchGestureRecognizer.view {
            faceView.transform = CGAffineTransformScale(faceView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale)
            //faceView.transform = CGAffineTransformRotate(faceView.transform, pinchGestureRecognizer.scale)
            pinchGestureRecognizer.scale = 1
        }
    }
    
    func onFaceRotate(sender: UIRotationGestureRecognizer) {
        let rotationGestureRecognizer = sender
        
        if let faceView = rotationGestureRecognizer.view {
            faceView.transform = CGAffineTransformRotate(faceView.transform, rotationGestureRecognizer.rotation)
            rotationGestureRecognizer.rotation = 0
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func onFacePanGesture(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(view)
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onFacePan:")
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onFacePinch:")
            pinchGestureRecognizer.delegate = self
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            
            let rotateGestureRecongizer = UIRotationGestureRecognizer(target: self, action: "onFaceRotate:")
            rotateGestureRecongizer.delegate = self
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecongizer)
            
            newlyCreatedFace.userInteractionEnabled = true
            
            faceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: faceOriginalCenter.x + translation.x, y: faceOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
        }

    }
    
    @IBAction func onTrayPanGesture(sender: UIPanGestureRecognizer) {
        let panGestureRecognizer = sender
        let point = panGestureRecognizer.locationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        let translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if velocity.y > 0 {
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20.0, options: nil, animations: { () -> Void in
                    self.trayView.center = self.trayClosedPosition
                    }, completion: { (Bool) -> Void in
                        
                })

            } else if velocity.y < 0 {
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20.0, options: nil, animations: { () -> Void in
                    self.trayView.center = self.trayOpenPosition
                }, completion: { (Bool) -> Void in
                    
                })
                
            } else {
                println("no velocity")
            }
        }

    }
}

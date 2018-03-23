//
//  ViewController.swift
//  CircleSpawn
//
//  Created by Lubomir Olshansky on 21/03/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var initialCenter: CGPoint?
    var initialPoint: CGPoint?
    var correct: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.myViewDoubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        self.view.addGestureRecognizer(doubleTapGesture)
    }
    
    var doubleTapGesture  = UITapGestureRecognizer()
    var tripleTapGesture  = UITapGestureRecognizer()
    
    @objc func myViewDoubleTapped(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        let circleView = UIView(frame: CGRect(x: touchPoint.x - 50, y: touchPoint.y - 50, width: 100, height: 100))
        circleView.backgroundColor = UIColor.randomBrightColor()
        circleView.layer.cornerRadius = 50
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.15
        longPressRecognizer.delegate = self
        circleView.addGestureRecognizer(longPressRecognizer)
        tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.myViewTripleTapped))
        tripleTapGesture.numberOfTapsRequired = 3
        tripleTapGesture.delegate = self
        doubleTapGesture.require(toFail: tripleTapGesture)
        circleView.addGestureRecognizer(tripleTapGesture)
        self.view.addSubview(circleView)
    }
    
    @objc func myViewTripleTapped(touch: UITapGestureRecognizer) {
        guard let view = touch.view else {
            return
        }
       view.removeFromSuperview()
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer)  {
        print("long press detected")
        if recognizer.state == UIGestureRecognizerState.began {
             print("long press began")
            guard let view = recognizer.view else {
                return
            }
                UIView.animate(withDuration: 0.3, animations: {
                    view.frame.size.width += 20
                    view.frame.size.height += 20
                    view.layer.cornerRadius += 10
                    view.alpha = 0.5
                }, completion: nil)
            
            initialCenter = view.center
            initialPoint = recognizer.location(in: self.view)
            guard let originalCenter = initialCenter else {
                return
            }
            guard let originalPoint = initialPoint else {
                return
            }
            correct = CGPoint(x:originalPoint.x - originalCenter.x, y:originalPoint.y - originalCenter.y)
    
        }
        else if recognizer.state == .changed {
             print("long press changed")
            guard let correction = correct else {
                return
            }
            guard let view = recognizer.view else {
                return
            }
        
            let location = recognizer.location(in: self.view)
            view.center = CGPoint(x:(view.center.x - correction.x) + (location.x - view.center.x),
                                              y:(view.center.y - correction.y) + (location.y - view.center.y))
        }
        else if recognizer.state == UIGestureRecognizerState.ended{
             print("long press ended")
            if let view = recognizer.view {
                UIView.animate(withDuration: 0.5, animations: {
                    view.frame.size.width -= 20
                    view.frame.size.height -= 20
                    view.layer.cornerRadius -= 10
                    view.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return random(min: 0.0, max: 1.0)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(max > min)
        return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

extension UIColor {
    static func randomBrightColor() -> UIColor {
        return UIColor(hue: .random(),
                       saturation: .random(min: 0.5, max: 1.0),
                       brightness: .random(min: 0.7, max: 1.0),
                       alpha: 1.0)
    }
}
extension ViewController: UIGestureRecognizerDelegate {
    
}

//
//  ViewController.swift
//  CircleSpawn
//
//  Created by Lubomir Olshansky on 21/03/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.myViewTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.myViewTapped))
        tripleTapGesture.numberOfTapsRequired = 3
        tripleTapGesture.numberOfTouchesRequired = 1
        tripleTapGesture.delegate = self
        self.view.addGestureRecognizer(doubleTapGesture)
    }
    
    var doubleTapGesture  = UITapGestureRecognizer()
    var tripleTapGesture  = UITapGestureRecognizer()
    
    @objc func myViewTapped(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        let circleView = UIView(frame: CGRect(x: touchPoint.x - 50, y: touchPoint.y - 50, width: 100, height: 100))
        circleView.backgroundColor = UIColor.randomBrightColor()
        circleView.layer.cornerRadius = 50
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.3
        longPressRecognizer.delegate = self
        circleView.addGestureRecognizer(longPressRecognizer)
        circleView.addGestureRecognizer(tripleTapGesture)
        self.view.addSubview(circleView)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer)  {
        print("long press detected")
        if recognizer.state == UIGestureRecognizerState.began {
             print("long press began")
            if let view = recognizer.view {
                UIView.animate(withDuration: 0.5, animations: {
                    view.frame.size.width += 10
                    view.frame.size.height += 10
                    view.layer.cornerRadius += 5
                    view.alpha = 0.5
                }, completion: nil)
            }
        }
        else if recognizer.state == .changed {
             print("long press changed")
            guard let view = recognizer.view else {
                return
            }

            let location = recognizer.location(in: self.view)
            view.center = CGPoint(x:view.center.x + (location.x - view.center.x),
                                              y:view.center.y + (location.y - view.center.y))
        }
        else if recognizer.state == UIGestureRecognizerState.ended{
             print("long press ended")
            if let view = recognizer.view {
                UIView.animate(withDuration: 0.5, animations: {
                    view.frame.size.width -= 10
                    view.frame.size.height -= 10
                    view.layer.cornerRadius -= 5
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

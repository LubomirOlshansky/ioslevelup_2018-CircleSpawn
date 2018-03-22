//
//  ViewController.swift
//  CircleSpawn
//
//  Created by Lubomir Olshansky on 21/03/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var viewTap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.myViewTapped))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.numberOfTouchesRequired = 1
        viewTap.addGestureRecognizer(tapGesture)
    }
    
  
    
    var tapGesture  = UITapGestureRecognizer()
    
    @objc func myViewTapped(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        let circleView = UIView(frame: CGRect(x: touchPoint.x - 50, y: touchPoint.y - 50, width: 100, height: 100))
        circleView.backgroundColor = UIColor.randomBrightColor()
        circleView.layer.cornerRadius = 50
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        longPressRecognizer.delegate = self
        circleView.addGestureRecognizer(longPressRecognizer)
        self.view.addSubview(circleView)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer)  {
        print("long press detected")
        if recognizer.state == UIGestureRecognizerState.began {
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            panRecognizer.delegate = self
            recognizer.view?.addGestureRecognizer(panRecognizer)
            if let view = recognizer.view {
                UIView.animate(withDuration: 0.5, animations: {
                    view.frame.size.width += 10
                    view.frame.size.height += 10
                    view.layer.cornerRadius += 5
                    view.alpha = 0.5
                }, completion: nil)
            }
            
            print("long press began")
        }
        if recognizer.state == UIGestureRecognizerState.ended{
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
    @objc func handlePan(recognizer: UIPanGestureRecognizer)  {
        print("pan detected")
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
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

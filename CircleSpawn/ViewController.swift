//
//  ViewController.swift
//  CircleSpawn
//
//  Created by Lubomir Olshansky on 21/03/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var circleView: UIView!
    
    @IBOutlet weak var viewTap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        circleView.layer.cornerRadius = 50
        circleView.backgroundColor = UIColor.randomBrightColor()
        
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.myViewTapped))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.numberOfTouchesRequired = 1
        viewTap.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tapGesture  = UITapGestureRecognizer()
    @objc func myViewTapped(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        let circleView1 = UIView(frame: CGRect(x: touchPoint.x, y: touchPoint.y, width: 100, height: 100))
        circleView1.backgroundColor = UIColor.randomBrightColor()
        circleView1.layer.cornerRadius = 50
        self.view.addSubview(circleView1)
        
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

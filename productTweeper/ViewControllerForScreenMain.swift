//
//  ViewControllerForScreenMain.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit
import ASToolkit

class ViewControllerForScreenMain: UIViewController {

    
    @IBOutlet var viewForImageTop       : UIImageView!
    @IBOutlet var viewForImageBottom    : UIImageView!
    @IBOutlet var buttonForSEARCH       : UIButton!
    @IBOutlet var buttonForLIVESTREAM   : UIButton!
    @IBOutlet var buttonForFILTER       : UIButton!
    @IBOutlet var buttonForPREFERENCES  : UIButton!
    
    private var buttons                 : [UIButton] = []
    private var gradient                : CAGradientRadialLayer!
    private var stack                   : UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main"
        
        self.stack = buttonForSEARCH.superview as! UIStackView
        
//        stack.translatesAutoresizingMaskIntoConstraints=false
        stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        if false {
            viewForImageTop.translatesAutoresizingMaskIntoConstraints=false
            viewForImageTop.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height/3.0).isActive=true
            viewForImageTop.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        }
        else {
            viewForImageTop.center.x = self.view.center.x
            viewForImageTop.center.y = self.view.frame.top/5.0
            viewForImageTop.translatesAutoresizingMaskIntoConstraints=true
        }

//        viewForImageTop.align(above:viewForMenu, constant:16)
//        viewForImageTop.alignCenterXWithParent(constant:0)

        viewForImageBottom.translatesAutoresizingMaskIntoConstraints=false
        viewForImageBottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive=true //self.view.frame.height/2.5).isActive=true
        viewForImageBottom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        viewForImageBottom.alpha = 0.6

        let viewForMenu = buttonForSEARCH.superview!
        
        viewForMenu.translatesAutoresizingMaskIntoConstraints=false
        viewForMenu.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive=true
        viewForMenu.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        
        self.buttons = [
            buttonForLIVESTREAM!, buttonForSEARCH!, buttonForFILTER!, buttonForPREFERENCES!
        ]
        
        let fontSize:CGFloat = 24
        let font = UIFont.init(name: "Gill Sans", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        for button in [buttonForLIVESTREAM!, buttonForFILTER!] {
            button.setAttributedTitle((button.title(for: .normal) ?? "?") | font | UIColor.white, for: .normal)
            button.setAttributedTitle((button.title(for: .disabled) ?? "?") | font | UIColor(white:1, alpha:0.6), for: .disabled)
            button.backgroundColor = UIColor(white: 1, alpha: 0.2)
        }

        for button in [buttonForSEARCH!, buttonForPREFERENCES!] {
            button.setAttributedTitle((button.title(for: .normal) ?? "?") | font | UIColor(white:1, alpha:0.90), for: .normal)
            button.setAttributedTitle((button.title(for: .disabled) ?? "?") | font | UIColor(white:1, alpha:0.6), for: .disabled)
            button.backgroundColor = UIColor(white: 1, alpha: 0.15)
        }
        
        for button in buttons {
            button.sizeToFit()
            button.contentEdgeInsets = UIEdgeInsets(all: 12)
            button.translatesAutoresizingMaskIntoConstraints=false
            button.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive=true
        }

        // "background gradient"

        let gradientView = UIView(frame:self.view.frame)
        
        self.view.insertSubview(gradientView, at: 0)
        
        gradient = CAGradientRadialLayer()
        
        gradient.bounds = self.view.bounds
        gradient.colors = [
            UIColor.init(hue:0.58, saturation:1.0, brightness:1.0, alpha:1.0).cgColor,
            UIColor.white.cgColor
        ]
        gradient.radius = self.view.bounds.height
        gradient.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        //        gradient.frame.origin = CGPoint(x:0,y:0)
        gradient.anchorPoint = CGPoint(x:0,y:0)
        
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        // motion effect
        
        let margin:CGFloat = 50
        
        let motionX = UIInterpolatingMotionEffect.init(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        motionX.minimumRelativeValue = -margin
        motionX.maximumRelativeValue = +margin
        
        let motionY = UIInterpolatingMotionEffect.init(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        motionY.minimumRelativeValue = -margin
        motionY.maximumRelativeValue = +margin
        
        let motionEffect = UIMotionEffectGroup()
        motionEffect.motionEffects = [motionX,motionY]
        
        self.viewForImageTop.addMotionEffect(motionEffect)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden=true
        
        for button in buttons {
            button.isSelected = false
            button.isEnabled = true
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // radio effect
        
        let radius = self.view.frame.diagonal
        let diameter = radius * 2
        let count = 12
        let duration = 24.0
        for animation in 0..<count
        {
            let radioWaveView = UIView(frame:CGRect(origin : self.viewForImageTop.center - radius,
                                                    size   : CGSize(side:diameter)))
            
            self.view.insertSubview(radioWaveView, at: 1)
            
            radioWaveView.backgroundColor = .clear
            
            let circle = UIBezierPath()
            circle.addArc(withCenter : CGPoint(xy:radius),
                          radius     : radius,
                          startAngle : 0,
                          endAngle   : .pi * 2,
                          clockwise  : false)
            circle.close()
            
            let layer = CAShapeLayer()
            
            layer.strokeColor   = UIColor.white.cgColor
            layer.fillColor     = UIColor(hsba:[0,0,0,0.0]).cgColor
            layer.lineWidth     = 30
            layer.path          = circle.cgPath
            
            radioWaveView.layer.addSublayer(layer)
            
            radioWaveView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            radioWaveView.alpha = 0.1
            
            let delay = Double(animation)/Double(count)*duration
            UIView.animate(withDuration: TimeInterval(duration), delay: delay, options: [.repeat, .curveLinear], animations: {
                radioWaveView.transform = CGAffineTransform(scaleX: 1, y: 1)
                radioWaveView.alpha = 0.02
            }) { finished in
                print("finished=\(finished) @ \(delay)")
            }

        }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.viewForImageTop.transform = CGAffineTransform.init(scaleX: 1.04, y: 1.1)
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden=false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapOnButton              (_ sender:UIControl!) {
        sender.isSelected=true
        for button in buttons {
            guard button != sender else { continue }
            button.isSelected = false
            button.isEnabled = false
        }
    }
    
    @IBAction func unwindToScreenMain(unwindSegue: UIStoryboardSegue) {
        for button in buttons {
            button.isSelected = false
            button.isEnabled = true
        }
    }

}

open class CADrawLayer : CALayer {

    public typealias Drawing = (CALayer, CGContext)->Void
    
    var drawings:[Drawing] = []
    
    override public init() {
        super.init()
        self.needsDisplayOnBoundsChange=true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func add(drawing:@escaping Drawing) {
        drawings.append(drawing)
    }
    
    override open func draw(in context: CGContext) {
        for drawing in Array<Drawing>(drawings) {
            drawing(self, context)
        }
    }

}

open class UIDrawView : UIView {
    
    public typealias Drawing = (UIView,CGContext,CGRect)->Void
    
    var drawings:[Drawing] = []
    
    public func add(drawing:@escaping Drawing) {
        drawings.append(drawing)
    }

    override open func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        for drawing in Array<Drawing>(drawings) {
            drawing(self, context, rect)
        }
    }
}


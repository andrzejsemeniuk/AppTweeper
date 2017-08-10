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
    @IBOutlet var buttonForLIVESEARCH   : UIButton!
    @IBOutlet var buttonForSEARCH       : UIButton!
    @IBOutlet var buttonForFILTER       : UIButton!
    @IBOutlet var buttonForPREFERENCES  : UIButton!
    
    private var buttons                 : [UIButton] = []
    private var gradient                : CAGradientRadialLayer!
    private var stack                   : UIStackView!
    private var gradientView            : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main"
        
        self.buttonForLIVESEARCH.isHidden = true
        
        self.stack = buttonForSEARCH.superview as! UIStackView
        
        stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        viewForImageTop.translatesAutoresizingMaskIntoConstraints=false
        viewForImageTop.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height/3.5).isActive=true
        viewForImageTop.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true

        viewForImageBottom.translatesAutoresizingMaskIntoConstraints=false
        viewForImageBottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive=true //self.view.frame.height/2.5).isActive=true
        viewForImageBottom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        viewForImageBottom.alpha = 0.7

        let viewForMenu = buttonForSEARCH.superview!
        
        viewForMenu.translatesAutoresizingMaskIntoConstraints=false
        viewForMenu.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive=true
        viewForMenu.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        
        let fontSize:CGFloat = 36
        let font = UIFont.init(name: "Gill Sans", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        self.buttons = [
            buttonForSEARCH!, buttonForLIVESEARCH!, buttonForFILTER!, buttonForPREFERENCES!
        ]
        
        for (index,button) in buttons.enumerated() {
            if index.isEven {
                button.setAttributedTitle((button.title(for: .normal) ?? "?") | font | UIColor(white:1, alpha:0.90), for: .normal)
                button.setAttributedTitle((button.title(for: .selected) ?? "?") | font | UIColor(white:1, alpha:0.6), for: .disabled)
                button.backgroundColor = UIColor(white: 1, alpha: 0.25)
            }
            else {
                button.setAttributedTitle((button.title(for: .normal) ?? "?") | font | UIColor.white, for: .normal)
                button.setAttributedTitle((button.title(for: .selected) ?? "?") | font | UIColor(white:1, alpha:0.6), for: .disabled)
                button.backgroundColor = UIColor(white: 1, alpha: 0.3)
            }
            
            button.sizeToFit()
            button.contentEdgeInsets = UIEdgeInsets(all: 12)
            button.translatesAutoresizingMaskIntoConstraints=false
            button.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive=true
        }

        // "background gradient"

        self.gradientView = UIView(frame:self.view.frame)
        
        self.view.insertSubview(gradientView, at: 0)
        
        // motion effect
        
        let margin:CGFloat = 15
        
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
            button.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        }
        
        // gradient
        
        self.gradient?.removeFromSuperlayer()
        
        self.gradient = CAGradientRadialLayer()
        
        gradient.bounds = self.view.bounds
        gradient.colors = [
            AppDelegate.instance.preferences.colorOfBackground.value.cgColor,
            UIColor.white.cgColor
        ]
        gradient.radius = self.view.bounds.height
        gradient.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        //        gradient.frame.origin = CGPoint(x:0,y:0)
        gradient.anchorPoint = CGPoint(x:0,y:0)
        
        self.gradientView.layer.insertSublayer(gradient, at: 0)

        // logo
        
        self.viewForImageTop.layer.shadowRadius     = AppDelegate.instance.preferences.titleShadowRadius.value
        self.viewForImageTop.layer.shadowColor      = AppDelegate.instance.preferences.titleShadowColor.value.cgColor // UIColor(hsb:[0.6,1.0,0.3]).cgColor
        self.viewForImageTop.layer.shadowOffset     = CGSize(side: AppDelegate.instance.preferences.titleShadowOffset.value)
        self.viewForImageTop.layer.shadowOpacity    = AppDelegate.instance.preferences.titleShadowAlpha.value // 0.4
        
    }
    
    private var appearance = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        appearance += 1
        
        // buttons
        
        let durationOfAppearance:Double
        
        if appearance > 1 {
            durationOfAppearance = AppDelegate.instance.preferences.durationOfMainMenuDisplay.value
        }
        else {
            durationOfAppearance = AppDelegate.instance.preferences.durationOfMainMenuDisplayInitially.value
        }
        
        for (index,button) in buttons.enumerated() {
            UIView.animate(withDuration: durationOfAppearance, delay:Double(index)/8.0, options: [.curveEaseOut], animations: {
                button.transform = CGAffineTransform.identity
            }) { finished in
            }
        }
        
        // radio effect
        
        let radioWaveTag = 999
        
        // remove previous signals
        if true {
            let previous = self.view.subviews.filter {
                $0.tag == radioWaveTag
            }
            for subview in previous {
                UIView.animate(withDuration: 3.0) {
                    subview.alpha = 0
                    subview.removeFromSuperview()
                }
            }
        }
        
        let radius      = max(1.0,self.view.frame.diagonal * AppDelegate.instance.preferences.signalRadius.value)
        let diameter    = radius * 2
        let count       = AppDelegate.instance.preferences.signalCount.value
        let duration    = max(1.0,AppDelegate.instance.preferences.signalDuration.value)
        
        for animation in 0..<count
        {
            let radioWaveView = UIView(frame:CGRect(origin : self.viewForImageTop.center - radius,
                                                    size   : CGSize(side:diameter)))
            
            radioWaveView.tag = radioWaveTag
            
            self.view.insertSubview(radioWaveView, at: 1)
            
            radioWaveView.backgroundColor = .clear
            radioWaveView.alpha = AppDelegate.instance.preferences.signalAlpha.value
            
            let circle = UIBezierPath()
            circle.addArc(withCenter : CGPoint(xy:radius),
                          radius     : radius,
                          startAngle : 0,
                          endAngle   : .pi * 2,
                          clockwise  : false)
            circle.close()
            
            let layer = CAShapeLayer()
            
            layer.strokeColor   = AppDelegate.instance.preferences.signalColor.value.cgColor
            layer.fillColor     =
                AppDelegate.instance.preferences.signalBackgroundColor.value.withAlphaComponent(
                    AppDelegate.instance.preferences.signalBackgroundAlpha.value).cgColor
//                UIColor(hsba:[0,0,0,0.0]).cgColor
            layer.lineWidth     = AppDelegate.instance.preferences.signalThickness.value
            layer.path          = circle.cgPath
            
            radioWaveView.layer.addSublayer(layer)
            
            radioWaveView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
//            radioWaveView.alpha = 0.05
            
            let delay = Double(animation)/Double(count)*duration
            UIView.animate(withDuration: TimeInterval(duration), delay: delay, options: [.repeat, .curveLinear], animations: {
                radioWaveView.transform = CGAffineTransform(scaleX: 1, y: 1)
                radioWaveView.alpha = 0.01
            }) { finished in
                print("finished animation (\(animation)) for circle")
            }
        }
        
        // for some reason this animation finishes immediately on 2nd appearance of vc
        if false {
            UIView.animate(withDuration: duration/Double(count)/2, delay: 1, options: [.repeat, .autoreverse], animations: {
                self.viewForImageTop.transform = CGAffineTransform.init(scaleX: 1.02, y: 1.04)
            }) { finished in
                print("finished title animation")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden=false
        
        for (index,button) in buttons.enumerated() {
            UIView.animate(withDuration: 0.4, delay: Double(index)/8.0, options: [], animations: {
                button.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            }) { finished in
            }
        }
        
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

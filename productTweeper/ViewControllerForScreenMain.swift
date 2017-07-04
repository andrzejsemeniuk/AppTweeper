//
//  ViewControllerForScreenMain.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit

class ViewControllerForScreenMain: UIViewController {

    
    @IBOutlet var viewForImageTop       : UIImageView!
    @IBOutlet var viewForImageBottom    : UIImageView!
    @IBOutlet var buttonForSEARCH       : UIButton!
    @IBOutlet var buttonForLIVESTREAM   : UIButton!
    @IBOutlet var buttonForFILTER       : UIButton!
    @IBOutlet var buttonForPREFERENCES  : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewForImageTop.translatesAutoresizingMaskIntoConstraints=false
        viewForImageTop.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height/4.0).isActive=true
        viewForImageTop.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true

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
        
        
        
        for button in [buttonForSEARCH, buttonForFILTER, buttonForLIVESTREAM, buttonForPREFERENCES] {
            guard let button = button else { continue }
            buttonForSEARCH.translatesAutoresizingMaskIntoConstraints=true
            button.frame.size.width = self.view.frame.width
        }
        
        for button in [buttonForSEARCH, buttonForFILTER] {
            guard let button = button else { continue }
            button.setTitleColor(UIColor(white:1,alpha:1.0), for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.backgroundColor = UIColor(white: 1, alpha: 0.2)
        }

        for button in [buttonForLIVESTREAM, buttonForPREFERENCES] {
            guard let button = button else { continue }
            button.setTitleColor(UIColor(white:1,alpha:0.95), for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.backgroundColor = UIColor(white: 1, alpha: 0.15)
        }
        
        // "background gradient"

        let gradient = CAGradientRadialLayer()
        
        gradient.bounds = self.view.bounds
        gradient.colors = [
            UIColor.init(hue:0.58, saturation:1.0, brightness:1.0, alpha:1.0).cgColor,
            UIColor.white.cgColor
        ]
        gradient.radius = self.view.bounds.height
        gradient.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        //        gradient.frame.origin = CGPoint(x:0,y:0)
        gradient.anchorPoint = CGPoint(x:0,y:0)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private var tapped = false
    
    @IBAction func tapOnButtonSEARCH        (_ sender:UIControl!) {
        if !tapped {
            tapped = true
            sender.isSelected=true
            print("SEARCH")
        }
    }
    
    @IBAction func tapOnButtonLIVESTREAM    (_ sender:UIControl!) {
        if !tapped {
            tapped = true
            sender.isSelected=true
            print("LIVE-STREAM")
        }
    }
    
    @IBAction func tapOnButtonFILTER        (_ sender:UIControl!) {
        if !tapped {
            tapped = true
            sender.isSelected=true
            print("FILTER")
        }
    }
    
    @IBAction func tapOnButtonPREFERENCES   (_ sender:UIControl!) {
        if !tapped {
            tapped = true
            sender.isSelected=true
            print("PREFERENCES")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tapped = false

        for button in [buttonForSEARCH, buttonForFILTER, buttonForLIVESTREAM, buttonForPREFERENCES] {
            guard let button = button else { continue }
            button.isSelected = false
        }
        
    }
    
}

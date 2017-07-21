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
        
        viewForImageTop.translatesAutoresizingMaskIntoConstraints=false
        viewForImageTop.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height/3.0).isActive=true
//        viewForImageTop.bottomAnchor.constraint(equalTo: stack.topAnchor).isActive = true
//        viewForImageTop.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
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
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden=true
        
        for button in buttons {
            button.isSelected = false
            button.isEnabled = true
        }
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

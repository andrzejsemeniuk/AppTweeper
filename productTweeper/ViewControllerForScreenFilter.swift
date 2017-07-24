//
//  ViewControllerForScreenFilter.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit

class ViewControllerForScreenFilter : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak  var textView            : UITextView!
    
    @IBOutlet weak  var segmentedControl    : UISegmentedControl!
    
    var segmentedControlTitle               : String                = ""
    
    var instructions                        : String {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return "Enter comma separated words.  Tweets containing these words will be filtered out of search results."
        default:
            return "Enter comma separated user names.  Tweets from these users will be filtered out of search results."
        }
    }
    
    
    
    override func viewDidLoad ()
    {
        super.viewDidLoad ()
        
        
        self.title = "Filter"
        
        
        segmentedControl.addTarget(self, action: #selector(ViewControllerForScreenFilter.actionOnSegmentedControl(_:)), for: .valueChanged)
        
        segmentedControlTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        segmentedControl.sizeToFit()
        
        
        textView.delegate = self
        
        textView.text = UserDefaults.standard.string(forKey: segmentedControlTitle)
        
        textView.layer.cornerRadius = 8
        
        self.automaticallyAdjustsScrollViewInsets = false
        

        textViewUpdate()
    }
    
    
    
    func actionOnSegmentedControl (_ s:UISegmentedControl)
    {
        let title: String = s.titleForSegment(at: s.selectedSegmentIndex)!
        
        let oldtext = textView.text
        
        print("old segment=\(segmentedControlTitle)")
        print("old text=\(oldtext ?? "nil")")
        
        // store+load
        
        let defaults = UserDefaults.standard
        
        defaults.set(textView.text, forKey:segmentedControlTitle)
        
        segmentedControlTitle = title
        
        textView.text = defaults.string(forKey: segmentedControlTitle)
        
        let newtext = textView.text
        
        print("new segment=\(segmentedControlTitle)")
        print("new text=\(newtext ?? "nil")")
        
        defaults.synchronize()
        
        self.textView.resignFirstResponder()
        
        textViewUpdate()
    }
    
    
    
    func textViewDidBeginEditing (_ textView: UITextView)
    {
        textView.textColor = UIColor.red
        if textView.text == instructions {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView)
    {
        if textView.text != instructions
        {
            let defaults = UserDefaults.standard
            
            defaults.set(textView.text, forKey:segmentedControlTitle)
            
            defaults.synchronize()
        }
        
        self.textView.resignFirstResponder()
        
        textViewUpdate()
    }
    
    
    func textViewUpdate()
    {
        if textView.text.length < 1 || textView.text == instructions {
            textView.text       = instructions
            textView.textColor  = UIColor.lightGray
        }
        else {
            textView.textColor  = UIColor.red
        }
    }
    
    
}

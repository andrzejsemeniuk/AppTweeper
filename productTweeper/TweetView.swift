//
//  TweetView.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/19/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class TweetView: UITableViewCell
{
    
    @IBOutlet weak var tweetImage:          UIImageView!
    @IBOutlet weak var tweetName:           UILabel!
    @IBOutlet weak var tweetHandle:         UILabel!
    @IBOutlet weak var tweetText:           UILabel!
    @IBOutlet weak var tweetTime:           UILabel!
    @IBOutlet weak var tweetReply:          UIButton!
    @IBOutlet weak var tweetRetweetCount:   UILabel!
    @IBOutlet weak var tweetRetweet:        UIButton!
    @IBOutlet weak var tweetFavorite:       UIButton!
    @IBOutlet weak var tweetFavoriteCount:  UILabel!
    @IBOutlet weak var tweetTextView:       UITextView!
    @IBOutlet weak var tweetFlag:           UIButton!
    
    var refresh:(()->())?
    
    func formattedTime(_ created_at: String) -> String
    {
        if 0 < created_at.length
        {
            print("formatTime:created_at: \(created_at)")
            
            let formatter: DateFormatter = DateFormatter()
            
            // FORMAT: created_at="Mon Nov 09 03:12:09 +0000 2015"
            
            formatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
            
            let DATE: Date                            = formatter.date(from: created_at)!
            let NOW: Date                             = Date()
            let SINCE: TimeInterval                   = NOW.timeIntervalSince(DATE)
            let THEN: Date                            = Date(timeInterval: SINCE, since: NOW)
            
            let conversionInfo: DateComponents        = (Calendar.current as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: NOW, to: THEN, options: [])
            
            if 0 < conversionInfo.year!                  { return String(format: "%ldy", conversionInfo.year!) }
            else if 0 < conversionInfo.month!            { return String(format: "%ldmth", conversionInfo.month!) }
            else if 0 < conversionInfo.day!              { return String(format: "%ldd", conversionInfo.day!) }
            else if 0 < conversionInfo.hour!             { return String(format: "%ldh", conversionInfo.hour!) }
            else if 0 < conversionInfo.minute!           { return String(format: "%ldm", conversionInfo.minute!) }
            else if 0 < conversionInfo.second!           { return String(format: "%lds", conversionInfo.second!) }
        }
        
        return ""
    }
    
    
    var model:TweetModel?
    {
        didSet
        {
            if let tweet = model {
                
                // NOTE: iOS 9 wants secure connections unless you explicitly tell it not in info.plist file
                if let url = NSURL(string:tweet.user.profile_image_url.replacingOccurrences(of: "http", with:"https")) {
                    tweetImage.setImage(fromURL:url as URL)
                }
                
                tweetImage.layer.cornerRadius       = 6.0
                tweetImage.clipsToBounds            = true
                
                tweetName.text                      = tweet.user.name
                tweetHandle.text                    = "@"+tweet.user.screen_name
                
                
                //            tweetText.lineBreakMode             = .ByWordWrapping
                //            tweetText.numberOfLines             = 0
                tweetTextView.text                  = tweet.text
                
                tweetTime.text                      = formattedTime(tweet.created_at)
                
                tweetFavoriteCount.text             = "\(tweet.favorites)"
                
                tweetFavorite.setImage(UIImage(named: "image-highlighted-star"), for: UIControlState.selected)
                
                if tweet.favorited!
                {
                    tweetFavorite.isSelected          = true
                    
                    tweetFavoriteCount.textColor    = UIColor(red: 1.0, green: 0.77, blue: 0.20, alpha: 1.0)
                }
                else
                {
                    tweetFavorite.isSelected          = false
                    
                    tweetFavoriteCount.textColor    = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                }
                
                
                tweetRetweet.setImage(UIImage(named: "image-highlighted-retweet"), for: UIControlState.selected)
                
                tweetRetweetCount.text              = "\(tweet.retweets)"
                
                if tweet.retweeted!
                {
                    tweetRetweet.isSelected           = true
                    
                    tweetRetweetCount.textColor     = UIColor(red: 0.4, green: 0.6, blue: 0.2, alpha: 1.0)
                }
                else
                {
                    tweetRetweet.isSelected           = false
                    
                    tweetRetweetCount.textColor     = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                }
                
                
                tweetFlag.isSelected = tweet.blocked
                
                print("flag selected \(tweetFlag.isSelected)")
                
                self.layoutIfNeeded()
            }
        }
    }
    
    
    
    @IBAction func handleReply          (_ sender: AnyObject) {
        print("reply")
    }
    
    @IBAction func handleRetweet        (_ sender: AnyObject) {
        print("retweet")
    }
    
    @IBAction func handleFavorite       (_ sender: AnyObject) {
        print("favorite")
    }
    
    @IBAction func handleFlag           (_ sender: AnyObject) {
        
        let tweet = model!
        
        print("tweet is blocked \(tweet.blocked)")
        
        if !tweet.blocked {
            
            let alert = UIAlertController(title:"Block", message:"Block tweet or user", preferredStyle:.actionSheet)
            
            let actionBlockUser = UIAlertAction(title:"Block User", style:.destructive, handler: {
                action in
                
                print("block user was called on \(tweet.user)")
                
                tweet.blocked=true;
                
                // "store user name"
                
                let defaults = UserDefaults.standard
                
                var value = ""
                
                if let users=defaults.string(forKey: "Users")
                {
                    value = users.trimmed()
                    
                    if value.empty {
                        value = tweet.user.name
                    }
                    else {
                        value += "," + tweet.user.name
                    }
                }
                else
                {
                    value = tweet.user.name
                }
                
                defaults.set(value,forKey:"Users")
                
                // "refresh table view"
                
                self.refresh?()
            })
            
            let actionBlockTweet = UIAlertAction(title:"Block Tweet", style:.destructive, handler: {
                action in
                
                print("block tweet was called on \(tweet.id)")
                
                tweet.blocked=true;
                
                // "add tweet to filter"
                
                let defaults = UserDefaults.standard
                
                var value = ""
                
                if let users=defaults.string(forKey: "Ids")
                {
                    value = users.trimmed()
                    
                    if value.empty {
                        value = String(tweet.id)
                    }
                    else {
                        value += "," + String(tweet.id)
                    }
                }
                else
                {
                    value = String(tweet.id)
                }
                
                defaults.set(value,forKey:"Ids")
                
                
                // "refresh table view"
                
                self.refresh?()
            })
            
            let actionCancel = UIAlertAction(title:"Cancel", style:.cancel, handler: {
                action in
            })
            
            alert.addAction(actionBlockUser)
            alert.addAction(actionBlockTweet)
            alert.addAction(actionCancel)
            
            AppDelegate.instance?.window?.rootViewController?.present(alert, animated:true, completion: {
                print("completed showing")
            })
            
        }
        
    }
    
    
    
    override func layoutMarginsDidChange()
    {
        super.preservesSuperviewLayoutMargins = false
        
        super.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        layoutMarginsDidChange()
        
//        self.tweetTextView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // TODO: ENABLE SELECTION VISUAL FEEDBACK
    }
    
}

/*
extension TweetView : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let request = URLRequest.init(url:URL)
        
        let vc = UIViewController()
        
        let wv = UIWebView()
        
        wv.loadRequest(request)
        
        AppDelegate.instance?.window?.rootViewController?.navigationController?.pushViewController(vc, animated: true)
        
        return false
    }
    
}
*/

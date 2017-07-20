//
//  Twitter.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/19/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class Twitter
{
    
    fileprivate init()
    {
    }
    
    static let instance                     = Twitter()
    
    static func consumerKey() -> String     { return Consumer.consumerKey }
    static func consumerSecret() -> String  { return Consumer.consumerSecret }
    
    static let url                          = URL(string: "https://api.twitter.com/1.1/")!
    
    typealias   Handler                     = (Bool)->Void
    
    typealias   HandlerForTweets            = ([TweetModel]?)->Void
    typealias   HandlerForGeo               = (JSON?)->Void
    
    
    
    
    struct Credentials
    {
        let name:       String
        let password:   String
        
        init(name:String, password:String)
        {
            assert(0 < name.length, "name must be non-empty")
            assert(0 < password.length, "password must be non-empty")
            self.name       = name
            self.password   = password
        }
    }
    
    
    fileprivate var access_token:String?
    
    
    func loginForApplicationOnly        (_ handler:@escaping Handler)
    {
        // note: see https://dev.twitter.com/oauth/application-only
        
        // note: the consumer key and secret must be url encoded separately, the concatenated
        //       using a colon (:), then the resulting string must be base64 encoded, and
        //       appended to a "Basic " string
        
        let authorization   = Twitter.consumerKey().urlEncoded + ":" + Twitter.consumerSecret().urlEncoded
        
        let parameters: [String : AnyObject] =
            [
                "grant_type"    : "client_credentials" as AnyObject
        ]
        
        let headers: [String : String] =
            [
                "Content-Type"  : "application/x-www-form-urlencoded;charset=UTF-8",
                "Authorization" : "Basic " + authorization.base64Encoded
        ]
        
        let address = "https://api.twitter.com/oauth2/token"
        
        Alamofire.request(address, method: .post, parameters: parameters, headers: headers).responseSwiftyJSON { response in
            
            // note: the response must contain a "token_type=bearer" and "access_token" keys
            if  let JSON    = response.value,
                let bearer  = JSON["token_type"].string,
                let token   = JSON["access_token"].string
            {
                self.access_token = token
                handler(true)
            }
            else
            {
                handler(false)
            }
        }
    }
    
    
    func tweetsFromGeo   (_ lat:Double? = 0, lng:Double? = 0, query:String? = nil, limit:UInt? = 3, handler:@escaping HandlerForGeo)
    {
        if access_token==nil
        {
            handler(nil)
            return
        }
        
        
        var parameters: [String : AnyObject] = [String : AnyObject]()
        
        
        if query != nil {
            parameters["query"]             = query! as AnyObject
        }
        if limit != nil {
            parameters["max_results"]       = limit! as AnyObject
        }
        
        
        let headers: [String : String] =
            [
                "Authorization" : "Bearer " + access_token!
        ]
        
        let address = "https://api.twitter.com/1.1/geo/search.json"
        
        Alamofire.request(address, method: .get, parameters: parameters, headers: headers).responseSwiftyJSON { response in
            handler(response.value)
        }
    }
    
    func tweetsForUser              (_ limit:UInt8, handler:HandlerForTweets)
    {
        
    }
    
    func tweetDetail         ()
    {
        
    }
    
    func notifications       ()
    {
        
    }
    
    func mentions            ()
    {
        
    }
    
    
    
    struct Search
    {
        struct GeoCode {
            let latitude:Double
            let longitude:Double
            let radius:Double
        }
        
        enum ResultType {
            case mixed
            case recent
            case popular
            
            var code: String {
                switch(self)
                {
                case .mixed:    return "mixed"
                case .recent:   return "recent"
                case .popular:  return "popular"
                }
            }
        }
    }
    
    
    
    func tweetsFromSearch       (_ query:          String,
                                 geocode:        Search.GeoCode? = nil,
                                 lang:           String? = nil,
                                 locale:         String? = nil,
                                 result_type:    Search.ResultType? = .recent,
                                 //        until:      NSDate? = nil,
        //        since_id:   Int64? = nil,
        //        max_id:     Int64? = nil,
        //        include_entities:   Bool? = true,
        //        callback:   String? = nil,
        count:          UInt? = 3,
        handler:        @escaping HandlerForTweets)
    {
        if access_token==nil
        {
            handler(nil)
            return
        }
        
        
        var parameters: [String : AnyObject] = [String : AnyObject]()
        
        
        parameters["q"]             = query as AnyObject
        
        if count != nil {
            parameters["count"]     = count! as AnyObject
        }
        
        
        let headers                 : [String : String]  = [
                "Authorization" : "Bearer " + access_token!
        ]
        
        let address = "https://api.twitter.com/1.1/search/tweets.json"
        
        Alamofire.request(address, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            
            if let data = response.data {
                
                let json = JSON(data:data)
                
                var tweets:[TweetModel] = [TweetModel]()
                
                for entry in json["statuses"]
                {
                    let tweet = TweetModel(entry.1)
                    
                    print("Twitter.search: collecting tweet with id \(tweet.id)")
                    print("Twitter.search: tweet=\(entry.1)")
                    
                    tweets.append(tweet)
                }
                
                handler(tweets)
            }
            else
            {
                handler(nil)
            }
        }
        
    }
    
    
    func userProfile             ()
    {
        
    }
    
    
}

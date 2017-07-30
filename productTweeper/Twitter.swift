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
    // MARK: - TYPES
    
    struct Request {
        
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
        
        
        
    }
    
    typealias   Handler                     = (Bool)->Void
    typealias   HandlerForTweets            = ([TweetModel]?)->Void
    typealias   HandlerForGeo               = (JSON?)->Void
    

    
    // MARK: - STATIC PROPERTIES
    
    static let instance                     = Twitter()
    

    
    // MARK: - INSTANCE PROPERTIES
    
    private var access_token                : String?
    
    private var isConntected                : Bool {
        return access_token != nil
    }
    
    private var consumerKey                 : String {
        return Consumer.consumerKey
    }
    
    private var consumerSecret              : String {
        return Consumer.consumerSecret
    }
    
    private var isStreaming                 = false
    
    private var url                         : String {
        if isStreaming {
            return "https://stream.twitter.com/1.1"
        }
        return "https://api.twitter.com/1.1"
    }
    

    // MARK: - PRIVATE METHODS
    
    private init()
    {
    }
    
    // MARK: - PUBLIC METHODS
    
    func loginForApplicationOnly            (streaming:Bool = false, _ handler:@escaping Handler)
    {
        // note: see https://dev.twitter.com/oauth/application-only
        
        // note: the consumer key and secret must be url encoded separately, the concatenated
        //       using a colon (:), then the resulting string must be base64 encoded, and
        //       appended to a "Basic " string
        
        let authorization   = consumerKey.urlEncoded + ":" + consumerSecret.urlEncoded
        
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
                print("bearer=\(bearer)")
                self.access_token = token
                self.isStreaming = streaming
                handler(true)
            }
            else
            {
                self.access_token = nil
                handler(false)
            }
        }
    }
    
    
    func requestTweetsFromGeo               (_ lat:Double? = 0, lng:Double? = 0, query:String? = nil, limit:UInt? = 3, handler:@escaping HandlerForGeo)
    {
        if access_token==nil
        {
            handler(nil)
            return
        }
        
        var parameters                      = [String : AnyObject]()
        
        if query != nil {
            parameters["query"]             = query! as AnyObject
        }
        if limit != nil {
            parameters["max_results"]       = limit! as AnyObject
        }
        
        
        let headers: [String : String]      = [
                "Authorization" : "Bearer " + access_token!
        ]
        
        let address = url + "/geo/search.json"
        
        Alamofire.request(address, method: .get, parameters: parameters, headers: headers).responseSwiftyJSON { response in
            handler(response.value)
        }
    }
    
    func requestTweetsForUser               (_ limit:UInt8, handler:HandlerForTweets)
    {
        
    }
    
    func requestTweetDetail                 ()
    {
        
    }
    
    func notifications                      ()
    {
        
    }
    
    func mentions                           ()
    {
        
    }
    
    func requestTweetsFromSearch            (_ query:       String,
                                             geocode:       Request.Search.GeoCode?         = nil,
                                             lang:          String?                         = nil,
                                             locale:        String?                         = nil,
                                             result_type:   Request.Search.ResultType?      = .recent,
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
    
    
    func userProfile                        ()
    {
        
    }
    
    
    func requestStreamingTweetsFromSearch   ()
    {
        
    }
    
}

// TODO: ADD STREAM SEARCH API

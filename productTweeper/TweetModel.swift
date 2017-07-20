//
//  TweetData.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/19/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SwiftyJSON


class TweetModel: NSObject {
    
    
    var id:             Int
    var user:           UserData
    var text:           String
    var created_at:     String = ""
    
    var favorites:      Int
    var favorited:      Bool?
    
    var retweets:       Int
    var retweeted:      Bool?
    
    var blocked:        Bool = false
    
    
    override var description: String {
        return "[\(id),\(text)]"
    }
    
    
    init(_ data:JSON)
    {
        id              = data["id"].int!
        
        user            = UserData(data["user"])
        
        text            = data["text"].string!
        
        if let t = data["created_at"].string {
            created_at = t
        }
        
        favorites       = data["favorite_count"].int!
        favorited       = data["favorited"].bool
        
        retweets        = data["retweet_count"].int!
        retweeted       = data["retweeted"].bool
    }
}



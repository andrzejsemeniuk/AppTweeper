//
//  User.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/19/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserData: NSObject {
    
    var name:                   String
    var screen_name:            String
    var profile_image_url:      String
    
    override var description: String {
        return "name="+name+"@"+screen_name
    }
    
    init(_ data:JSON)
    {
        name                    = data["name"].string!
        screen_name             = data["screen_name"].string!
        profile_image_url       = data["profile_image_url"].string!
        //        description             = data["description"].string
    }
}

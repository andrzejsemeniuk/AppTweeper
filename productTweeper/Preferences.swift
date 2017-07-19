//
//  Preferences.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/18/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

class Preferences {
    
    var colorOfScreenTitleBackground                    = UIColor.init(hue:0.58, saturation:1.0, brightness:1.0, alpha:1.0)
    var colorOfScreenSearchListSeparator                = UIColor(white:220.0/255.0)
    
    static private var all:[Preferences]                = [Preferences()]
    
    static var current:Preferences {
        return all.first!
    }
}

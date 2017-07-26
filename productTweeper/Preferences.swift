//
//  Preferences.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/18/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

class Preferences : GenericManagerOfSettings {
    
    func synchronize() {
        UserDefaults.standard.synchronize()
    }

    var name                                            = GenericSetting<String>    (key:"name", first: "default")
    var styles                                          = GenericSetting<[String]>  (key:"styles", first: [])
    var audio                                           = GenericSetting<Bool>      (key:"audio", first: false)

    var colorOfBackground                               = GenericSetting<UIColor>   (key:"colorOfBackground", first: UIColor(hsb:[0.6,1.0,1.0]))
    var colorOfSelection                                = GenericSetting<UIColor>   (key:"colorOfSelection", first: .orange)
    var colorOfTitleText                                = GenericSetting<UIColor>   (key:"colorOfTitleText", first: .white)
    var colorOfHeaderText                               = GenericSetting<UIColor>   (key:"colorOfHeaderText", first: .gray)
    var colorOfFooterText                               = GenericSetting<UIColor>   (key:"colorOfFooterText", first: .gray)

    var signalColor                                     = GenericSetting<UIColor>   (key:"signalColor", first: UIColor.white)
    var signalAlpha                                     = GenericSetting<CGFloat>   (key:"signalAlpha", first: 0.2)
    var signalCount                                     = GenericSetting<Int>       (key:"signalCount", first: 12)
    var signalDuration                                  = GenericSetting<Double>    (key:"signalDuration", first: 6.0)
    
    var titleShadowRadius                               = GenericSetting<CGFloat>   (key:"titleShadowRadius", first: 0.2)
    var titleShadowDirection                            = GenericSetting<String>    (key:"titleShadowDirection", first: "3,3")
    var titleShadowColor                                = GenericSetting<UIColor>   (key:"titleShadowColor", first: UIColor.black)
    var titleShadowAlpha                                = GenericSetting<CGFloat>   (key:"titleShadowAlpha", first: 0.7)

    var tweetLimitOfDisplayCount                        = GenericSetting<Int>       (key:"tweetLimitOfDisplayCount", first: 120)
    var searchResultsLimit                              = GenericSetting<Int>       (key:"searchResultsLimit", first: 40)
    var separateSearchResults                           = GenericSetting<Bool>      (key:"separateSearchResults", first: true)
    var colorOfScreenSearchListSeparator                = GenericSetting<UIColor>   (key:"colorOfScreenSearchListSeparator", first: UIColor(white:220.0/255.0))
    
    var testFontName                                    = GenericSetting<String>    (key:"testFontName", first: UIFont.defaultFont.fontName)
    var testFont                                        = GenericSetting<UIFont>    (key:"testFont", first: UIFont.defaultFont)
    var testColor                                       = GenericSetting<UIColor>   (key:"testColor", first: .green)
    var testCGFloat                                     = GenericSetting<CGFloat>   (key:"testCGFloat", first: 0.2)
    var testDouble                                      = GenericSetting<Double>    (key:"testDouble", first: 12.345)
    var testString                                      = GenericSetting<String>    (key:"testString", first: "t e s t")
    var testBool                                        = GenericSetting<Bool>      (key:"testBool", first: false)
    var testInt                                         = GenericSetting<Int>       (key:"testInt", first: 131)
    

    static private var all:[Preferences]                = [Preferences()]
    
    static var current:Preferences {
        return all.first!
    }
}

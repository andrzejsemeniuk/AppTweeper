//
//  Preferences.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/18/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class Preferences : GenericManagerOfSettings {
    
    func synchronize() {
        UserDefaults.standard.synchronize()
    }

    init() {
    }
    
    var style                                           = GenericSetting<String>    (key:"style", first: "default")
    var styles                                          = GenericSetting<[String]>  (key:"styles", first: [])
    var audio                                           = GenericSetting<Bool>      (key:"audio", first: false)
    
    var lastSearchText                                  = GenericSetting<String>    (key:"lastSearchText", first: "?")


    var colorOfBackground                               = GenericSetting<UIColor>   (key:"colorOfBackground", first: UIColor(hue:0.58))
    var colorOfSelection                                = GenericSetting<UIColor>   (key:"colorOfSelection", first: .white)
    var colorOfTitleText                                = GenericSetting<UIColor>   (key:"colorOfTitleText", first: .white)
    var colorOfHeaderText                               = GenericSetting<UIColor>   (key:"colorOfHeaderText", first: .gray)
    var colorOfFooterText                               = GenericSetting<UIColor>   (key:"colorOfFooterText", first: .gray)

    var signalColor                                     = GenericSetting<UIColor>   (key:"signalColor", first: UIColor.white)
    var signalAlpha                                     = GenericSetting<CGFloat>   (key:"signalAlpha", first: 0.2)
    var signalBackgroundColor                           = GenericSetting<UIColor>   (key:"signalBackgroundColor", first: UIColor.white)
    var signalBackgroundAlpha                           = GenericSetting<CGFloat>   (key:"signalBackgroundAlpha", first: 0.0)
    var signalRadius                                    = GenericSetting<CGFloat>   (key:"signalRadius", first: 1.0)
    var signalCount                                     = GenericSetting<Int>       (key:"signalCount", first: 12)
    var signalDuration                                  = GenericSetting<Double>    (key:"signalDuration", first: 6.0)
    var signalThickness                                 = GenericSetting<CGFloat>   (key:"signalThickness", first: 30)
    
    var titleShadowColor                                = GenericSetting<UIColor>   (key:"titleShadowColor", first: UIColor.black)
    var titleShadowRadius                               = GenericSetting<CGFloat>   (key:"titleShadowRadius", first: 0.2)
    var titleShadowOffset                               = GenericSetting<CGFloat>   (key:"titleShadowOffset", first: 0)
    var titleShadowAlpha                                = GenericSetting<Float>     (key:"titleShadowAlpha", first: 0.4)

    var durationOfMainMenuDisplayInitially              = GenericSetting<Double>    (key:"durationOfMainMenuDisplayInitially", first: 0.8)
    var durationOfMainMenuDisplay                       = GenericSetting<Double>    (key:"durationOfMainMenuDisplay", first: 0.3)

    var maximumTweetsToDisplay                          = GenericSetting<Int>       (key:"maximumTweetsToDisplay", first: 999)
    var maximumResultsPerSearch                         = GenericSetting<Int>       (key:"maximumResultsPerSearch", first: 40)

    var maximumHistory                                  = GenericSetting<Int>       (key:"maximumHistory", first: 3)
    var enableHistory                                   = GenericSetting<Bool>      (key:"enableHistory", first: true)

    
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
    
}

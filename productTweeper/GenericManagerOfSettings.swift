//
//  GenericManagerOfSettings.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/29/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

protocol GenericManagerOfSettings : class {
    func synchronize    ()
    func encode         (data:inout [String:Any], withPrefix prefix:String?, withSuffix suffix:String?)
    func decode         (data:[String:Any], withPrefix prefix:String?, withSuffix suffix:String?)
    func reset          (withPrefix prefix:String?, withSuffix suffix:String?)
}

extension GenericManagerOfSettings {
    
    func encode(data:inout [String:Any], withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? ToDictionary {
                setting.to(dictionary:&data)
            }
        }
    }
    
    func decode(data:[String:Any], withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? FromDictionary {
                setting.from(dictionary:data)
            }
        }
    }
    
    func reset(withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? Resettable {
                setting.reset()
            }
        }
    }
    
}


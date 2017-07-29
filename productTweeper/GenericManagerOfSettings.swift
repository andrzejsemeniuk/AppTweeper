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
            if let setting = child.value as? GenericSetting<UIColor> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<UIFont> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<String> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<[String]> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<Bool> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<Int> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<UInt> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<Float> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<CGFloat> {
                setting.to(&data)
            }
            else if let setting = child.value as? GenericSetting<Double> {
                setting.to(&data)
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
            if let setting = child.value as? GenericSetting<UIColor> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<UIFont> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<String> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<[String]> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<Bool> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<Int> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<UInt> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<Float> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<CGFloat> {
                setting.from(data)
            }
            else if let setting = child.value as? GenericSetting<Double> {
                setting.from(data)
            }
        }
    }
    
}


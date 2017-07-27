//
//  GenericSetting.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/26/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class GenericSetting<TYPE> {
    public typealias Key = String
    public let key         : Key
    public let first       : TYPE
    public var query       : TYPE? {
        didSet (newValue) {
            if let newValue = newValue {
                if let v = newValue as? String {
                    UserDefaults.standard.set(string: v, forKey: key)
                }
                else if let v = newValue as? Double {
                    UserDefaults.standard.set(v, forKey: key)
                }
                else if let v = newValue as? Float {
                    UserDefaults.standard.set(v, forKey: key)
                }
                else if let v = newValue as? CGFloat {
                    UserDefaults.standard.set(v, forKey: key)
                }
                else if let v = newValue as? Int {
                    UserDefaults.standard.set(v, forKey: key)
                }
                else if let v = newValue as? Bool {
                    UserDefaults.standard.set(v, forKey: key)
                }
                else if let v = newValue as? UIColor {
                    UserDefaults.standard.set(color: v, forKey: key)
                }
                else if let v = newValue as? UIFont {
                    UserDefaults.standard.set(font: v, forKey: key)
                }
                else if let v = newValue as? URL {
                    UserDefaults.standard.set(v, forKey: key)
                }
                else if let v = newValue as? Date {
                    UserDefaults.standard.set(date: v, forKey: key)
                }
                else {
                    UserDefaults.standard.set(newValue, forKey: key)
                }
            }
            else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

    private var stored:TYPE? {
        if first is UIColor             { return UserDefaults.standard.color(forKey: key) as? TYPE }
        if first is UIFont              { return UserDefaults.standard.font(forKey: key) as? TYPE }
        if first is String              { return UserDefaults.standard.string(forKey: key) as? TYPE }
        if first is Date                { return UserDefaults.standard.date(forKey: key) as? TYPE }
//        if first is Double              { return UserDefaults.standard.double(forKey: key) as? TYPE }

        return UserDefaults.standard.value(forKey: key) as? TYPE
    }
    
    public var value:TYPE {
        return query!
    }
    
    public init(key:String, first:TYPE) {
        self.key = key
        self.first = first
        if let stored = self.stored {
            self.query = stored
        }
        else {
            self.query = first
        }
    }
    
    public func remove() {
        self.query = nil
    }
    
    public func reset() {
        self.query = first
    }
    
}


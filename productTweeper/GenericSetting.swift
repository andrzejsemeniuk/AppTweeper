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
    public var value       : TYPE {
        didSet (n) {
            if let v = n as? String {
                UserDefaults.standard.set(string: v, forKey: key)
            }
                //                else if let v = n as? Double {
                //                    UserDefaults.standard.set(v, forKey: key)
                //                }
                //                else if let v = n as? Float {
                //                    UserDefaults.standard.set(v, forKey: key)
                //                }
                //                else if let v = n as? CGFloat {
                //                    UserDefaults.standard.set(v, forKey: key)
                //                }
                //                else if let v = n as? Int {
                //                    UserDefaults.standard.set(v, forKey: key)
                //                }
                //                else if let v = n as? Bool {
                //                    UserDefaults.standard.set(v, forKey: key)
                //                }
            else if let v = n as? UIColor {
                UserDefaults.standard.set(color: v, forKey: key)
            }
            else if let v = n as? UIFont {
                UserDefaults.standard.set(font: v, forKey: key)
            }
            else if let v = n as? URL {
                UserDefaults.standard.set(v, forKey: key)
            }
            else if let v = n as? Date {
                UserDefaults.standard.set(date: v, forKey: key)
            }
            else {
                UserDefaults.standard.set(n, forKey: key)
            }
        }
    }
    
    internal var stored:TYPE? {
        if first is UIColor             { return UserDefaults.standard.color(forKey: key) as? TYPE }
        if first is UIFont              { return UserDefaults.standard.font(forKey: key) as? TYPE }
        if first is String              { return UserDefaults.standard.string(forKey: key) as? TYPE }
        if first is Date                { return UserDefaults.standard.date(forKey: key) as? TYPE }
        //        if first is Double              { return UserDefaults.standard.double(forKey: key) as? TYPE }
        
        return UserDefaults.standard.value(forKey: key) as? TYPE
    }
    
    public init(key:String, first:TYPE) {
        self.key = key
        self.first = first
        self.value = first
        
        if let stored = self.stored {
            self.value = stored
        }
    }
    
    public func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    public func reset() {
        self.value = first
    }
    
}


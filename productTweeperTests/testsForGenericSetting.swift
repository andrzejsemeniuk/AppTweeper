//
//  testsForGenericSetting.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/27/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest
@testable import productTweeper

class testsForGenericSetting: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testForDouble() {
        let value = 1.2345
        let setting = GenericSetting<Double>(key:"test-for-double", first:value)
        defer {
            setting.remove()
        }
        
        XCTAssertEqual(setting.value, value)
        XCTAssertEqual(setting.stored, value)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

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

    let double0 = 1.2345
    let double1 = 3.141

    func testForPersistance1() {
        let setting0 = GenericSetting<Double>(key:"test-for-persistance", first:double0)
        if setting0.stored != nil {
            setting0.remove()
        }
        XCTAssertEqual(setting0.stored, nil)
        
        let setting = GenericSetting<Double>(key:"test-for-persistance", first:double0)
        
        XCTAssertEqual(setting.first, double0)
        XCTAssertEqual(setting.value, double0)
        XCTAssertEqual(setting.stored, double0)
    }
    
    func testForPersistance2() {
        let setting = GenericSetting<Double>(key:"test-for-persistance", first:double1)
        
        XCTAssertEqual(setting.stored, double0)
        XCTAssertEqual(setting.value, double0)
        
        setting.remove()
    }
    
    func testForRemove() {
        let setting = GenericSetting<Double>(key:"test-for-remove", first:double0)
        XCTAssertEqual(setting.stored, double0)
        XCTAssertEqual(setting.value, double0)
        setting.remove()
        XCTAssertEqual(setting.stored, nil)
    }
    
    func testForSetValue() {
        let setting = GenericSetting<Double>(key:"test-for-setvalue", first:double1)
        XCTAssertEqual(setting.stored, double1)
        XCTAssertEqual(setting.value, double1)
        XCTAssertNotEqual(double0, double1)
        setting.value = double0
        XCTAssertEqual(setting.stored, double0)
        XCTAssertEqual(setting.value, double0)
        setting.remove()
        XCTAssertEqual(setting.stored, nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

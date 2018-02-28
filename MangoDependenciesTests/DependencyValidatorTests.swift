//
//  DependencyValidatorTests.swift
//  MangoDependenciesTests
//
//  Created by Raymond Gatz on 2/28/18.
//  Copyright © 2018 RayzorDragon. All rights reserved.
//

import XCTest

class DependencyValidatorTests: XCTestCase {
	
	var validator: DependencyValidator?
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		validator = DependencyValidator.init(classes: Array<PseudoClass>())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
		validator = nil
    }
    

	func testAddClass() {
		// ensure we start with 0 classes
		XCTAssertEqual(validator?.classes?.count, 0)
		
		let pClass = PseudoClass.init(name: "A", dependencies: ["B", "C"])
		validator?.addClass(pClass: pClass)
		
		// and now we have 1 class
		XCTAssertEqual(validator?.classes?.count, 1)
		
		// and it should match the class we created
		XCTAssertEqual(validator?.classes?.first, pClass)
		
	}
	
	func testFindPClass() {
		
		// ensure we start with 0 classes
		XCTAssertEqual(validator?.classes?.count, 0)
		
		let pClassA = PseudoClass.init(name: "A", dependencies: ["B", "C"])
		validator?.addClass(pClass: pClassA)
		let pClassB = PseudoClass.init(name: "B", dependencies: ["C", "E"])
		validator?.addClass(pClass: pClassB)
		let pClassC = PseudoClass.init(name: "C", dependencies: ["G"])
		validator?.addClass(pClass: pClassC)
		
		// and now we have 3 classes
		XCTAssertEqual(validator?.classes?.count, 3)
		
		// make sure that classes comparitor works for both matching and indicating not matching
		XCTAssertEqual(validator?.classes?.first, pClassA)
		XCTAssertEqual(validator?.classes?.last, pClassC)
		XCTAssertNotEqual(validator?.classes?.first, pClassB)
		
		// now to find classes
		
		let testClassA = validator?.findPClassWith(name: "A")
		XCTAssertEqual(testClassA, pClassA)
		let testClassB = validator?.findPClassWith(name: "B")
		XCTAssertEqual(testClassB, pClassB)
		let testClassC = validator?.findPClassWith(name: "C")
		XCTAssertEqual(testClassC, pClassC)
		let testClassG = validator?.findPClassWith(name: "G")
		XCTAssertNil(testClassG)
	}
	
	func testRecursiveDependCheck() {
		// ensure we start with 0 classes
		XCTAssertEqual(validator?.classes?.count, 0)
		
		let pClassA = PseudoClass.init(name: "A", dependencies: ["B", "C"])
		validator?.addClass(pClass: pClassA)
		let pClassB = PseudoClass.init(name: "B", dependencies: ["C", "E"])
		validator?.addClass(pClass: pClassB)
		let pClassC = PseudoClass.init(name: "C", dependencies: ["G"])
		validator?.addClass(pClass: pClassC)
		let pClassD = PseudoClass.init(name: "D", dependencies: ["A", "F"])
		validator?.addClass(pClass: pClassD)
		let pClassE = PseudoClass.init(name: "E", dependencies: ["F"])
		validator?.addClass(pClass: pClassE)
		let pClassF = PseudoClass.init(name: "F", dependencies: ["H"])
		validator?.addClass(pClass: pClassF)
		
		// validator should return that
		// A: BCEFGH
		// B: CEFGH
		// C: G
		// D: ABCEFGH
		// E: FH
		// F: H
		
		let validA = validator?.recursiveDependCheckFor(pClass: pClassA)
		XCTAssertEqual(validA!, ["B", "C", "G", "E", "F", "H", "C", "G"])
		let validB = validator?.recursiveDependCheckFor(pClass: pClassB)
		XCTAssertNotEqual(validB!, ["P"])
		let validC = validator?.recursiveDependCheckFor(pClass: pClassC)
		let validD = validator?.recursiveDependCheckFor(pClass: pClassD)
		let validE = validator?.recursiveDependCheckFor(pClass: pClassE)
		let validF = validator?.recursiveDependCheckFor(pClass: pClassF)
		
		let cleanA = validator?.cleanUp(array: validA!)
		XCTAssertEqual(cleanA, "BCEFGH")
		let cleanB = validator?.cleanUp(array: validB!)
		XCTAssertEqual(cleanB, "CEFGH")
		let cleanC = validator?.cleanUp(array: validC!)
		XCTAssertEqual(cleanC, "G")
		let cleanD = validator?.cleanUp(array: validD!)
		XCTAssertEqual(cleanD, "ABCEFGH")
		let cleanE = validator?.cleanUp(array: validE!)
		XCTAssertEqual(cleanE, "FH")
		let cleanF = validator?.cleanUp(array: validF!)
		XCTAssertEqual(cleanF, "H")
		
	}
	
	func testFullDependencyOutput() {
		let pClassA = PseudoClass.init(name: "A", dependencies: ["B", "C"])
		validator?.addClass(pClass: pClassA)
		let pClassB = PseudoClass.init(name: "B", dependencies: ["C", "E"])
		validator?.addClass(pClass: pClassB)
		let pClassC = PseudoClass.init(name: "C", dependencies: ["G"])
		validator?.addClass(pClass: pClassC)
		let pClassD = PseudoClass.init(name: "D", dependencies: ["A", "F"])
		validator?.addClass(pClass: pClassD)
		let pClassE = PseudoClass.init(name: "E", dependencies: ["F"])
		validator?.addClass(pClass: pClassE)
		let pClassF = PseudoClass.init(name: "F", dependencies: ["H"])
		validator?.addClass(pClass: pClassF)
		
		// validator should return that
		// A: BCEFGH
		// B: CEFGH
		// C: G
		// D: ABCEFGH
		// E: FH
		// F: H
		
		let final = validator?.determineDependencies()
		let check = "A: BCEFGH\nB: CEFGH\nC: G\nD: ABCEFGH\nE: FH\nF: H"
		
		XCTAssertEqual(final, check)
	}
	
//	func testCircularDependencyCatch() {
//		
//		let pClassA = PseudoClass.init(name: "A", dependencies: ["B"])
//		validator?.addClass(pClass: pClassA)
//		let pClassB = PseudoClass.init(name: "B", dependencies: ["C"])
//		validator?.addClass(pClass: pClassB)
//		let pClassC = PseudoClass.init(name: "C", dependencies: ["A"])
//		validator?.addClass(pClass: pClassC)
//		
//		let final = validator?.determineDependencies()
//		let contain = final!.contains("Circular Dependency Found")
//		
//		XCTAssertTrue(contain)
//	}
    
}

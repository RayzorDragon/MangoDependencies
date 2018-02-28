//
//  DependencyValidator.swift
//  MangoDependencies
//
//  Created by Raymond Gatz on 2/28/18.
//  Copyright © 2018 RayzorDragon. All rights reserved.
//

import Foundation



public class DependencyValidator {
	let noDataString = "No Data Found"
	let circleDependString = "Circular Dependency Found"
	
	var classes: Array<PseudoClass>?
	
	init (classes: Array<PseudoClass>) {
		self.classes = Array<PseudoClass>()
		for pClass in classes {
			self.addClass(pClass: pClass)
		}
	}
	
	func addClass(pClass: PseudoClass) {
		classes?.append(pClass)
	}
	
	public func determineDependencies() -> String {
		var finalString = String()
		
		if (classes?.isEmpty)! {
			finalString = noDataString
		} else {
			
			finalString = ""
			for pClass in (classes)! {
				let arrayDepend = self.recursiveDependCheckFor(pClass: pClass)
				// check if circleDependency detected
				if arrayDepend.contains(pClass.name!) {
					finalString.append(pClass.name! + ": " + circleDependString)
				} else {
					// if not, use this
					let stringDepend = cleanUp(array: arrayDepend)
					finalString.append(pClass.name! + ": " + stringDepend)
				}
				
				
				if pClass != classes?.last {
					finalString.append("\n")
				}
			}
			
		}
		
		return finalString
	}
	
	func recursiveDependCheckFor(pClass: PseudoClass) -> Array<String> {
		var stringArray = Array<String>()
		
		// run through every possible class
		for maybeClass in pClass.dependencies! {
			
			// make sure we don't already have this class in the system
			// FIXIT recursive break down, taking a break, will look at later
			//if !stringArray.contains(maybeClass) {
				stringArray.append(maybeClass) // add current class to array
				
				// see if the current class is listed in our array of classes with depedencies
				if let foundClass = findPClassWith(name: maybeClass) {
					// call this class again with the found class
					stringArray.append(contentsOf: recursiveDependCheckFor(pClass: foundClass))
					
				}
			//}
			
		}
		// return messy array of all dependencies of originally called class
		return stringArray
	}
	
	func cleanUp(array: Array<String>) -> String {
		
		// step one, clean out duplicate
		var cleanArray = Array<String>()
		
		for maybeClass in array {
			if !cleanArray.contains(maybeClass) {
				cleanArray.append(maybeClass)
			}
		}
		// step two, order
		cleanArray.sort { (lhs, rhs) -> Bool in
			return lhs.compare(rhs) == ComparisonResult.orderedAscending
		}
		
		// step three, convert to string
		var finalString = String()
		
		for maybeClass in cleanArray {
			finalString.append(maybeClass)
		}
		
		return finalString
	}
	
	func findPClassWith(name: String) -> PseudoClass? {
		
		for pClass in classes! {
			if pClass.name == name {
				return pClass
			}
		}
		
		return nil
	}
}

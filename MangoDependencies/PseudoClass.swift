//
//  PseudoClass.swift
//  MangoDependencies
//
//  Created by Raymond Gatz on 2/28/18.
//  Copyright © 2018 RayzorDragon. All rights reserved.
//

import Foundation

public struct PseudoClass {
	var name: String?
	var dependencies: Array<String>?
}

extension PseudoClass: Comparable {
	public static func < (lhs: PseudoClass, rhs: PseudoClass) -> Bool {
		return lhs.name!.caseInsensitiveCompare(rhs.name!) == ComparisonResult.orderedAscending
	}
	
	public static func == (lhs: PseudoClass, rhs: PseudoClass) -> Bool {
		return lhs.name == rhs.name &&
			lhs.dependencies! == rhs.dependencies!
	}
}

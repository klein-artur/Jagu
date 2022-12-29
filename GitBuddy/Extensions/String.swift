//
//  String.swift
//  GitBuddy
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func formatted(_ arguments: CVarArg...) -> String {
        return String(format: self, arguments: arguments)
    }
}

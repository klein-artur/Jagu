//
//  PasteboardService.swift
//  Jagu
//
//  Created by Artur Hellmann on 13.02.23.
//

import Foundation
import SwiftDose

class PasteboardService {
    @Dose(of: \.pasteboard) var pasteboard
    
    func copy(string: String) -> Bool {
        _ = pasteboard.declareTypes([.string], owner: nil)
        return pasteboard.setString(string, forType: .string)
    }
}

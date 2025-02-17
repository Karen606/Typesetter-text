//
//  Double.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 20.09.24.
//

import Foundation

extension Double {
    func formatString() -> String {
        if Double(Int(self)) == self {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }
}

//
//  Extensions.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 12.04.2022.
//

import Foundation

extension String {
    func capitlizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

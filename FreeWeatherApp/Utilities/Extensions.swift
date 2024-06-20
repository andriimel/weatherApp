//
//  Extensions.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 6/15/24.
//

import Foundation

extension String {
    func before(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let before = prefix(upTo: index)
            return String(before)
        }
        return ""
    }
    

}

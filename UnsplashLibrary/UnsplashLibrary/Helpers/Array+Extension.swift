//
//  Collection+Extension.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 26.03.2022.
//

import Foundation

public extension Array where Element: Equatable {
    /// Append an element at the end if it is not in the array, and removes an element from the array if the array contains this element
    /// - Parameter newElement: element to insert/remove.
    mutating func update(_ item: Element)  {
        if self.contains(item) {
            if let index = self.firstIndex(of: item){
                self.remove(at: index)
            }
        } else {
            self.append(item)
        }
    }
}

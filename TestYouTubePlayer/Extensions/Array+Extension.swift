//
//  Array+Extension.swift
//  TestYouTubePlayer
//
//  Created by Golos on 23.05.2022.
//

import Foundation

extension Array {
    func element(at index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

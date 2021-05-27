//
//  SelfConfiguringCell.swift
//  Harmony
//
//  Created by Macbook Pro on 26.05.2021.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func setupViews()
}

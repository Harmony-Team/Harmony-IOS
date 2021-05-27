//
//  JSONDecoder+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 24.05.2021.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, fromUrl url: String, completion: @escaping (T) -> Void) {
        guard let url = URL(string: url) else {
            fatalError("Invalid URL passed")
        }
        
        
    }
}

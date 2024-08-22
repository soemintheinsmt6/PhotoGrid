//
//  Environment.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import Foundation


enum Environment {
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("info.plist not found")
        }
        
        return dict
    }()
    
    static let baseURL: String = {
        guard let baseString = Environment.infoDict["BASE_URL"] as? String else {
            fatalError("baseURL not found")
        }
        
        let prefix = "https://"
        
        return prefix + baseString
    }()
    
}

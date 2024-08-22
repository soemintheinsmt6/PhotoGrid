//
//  PhotoModel.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let author: String
    let url: String
    let downloadURL: String
    
    var resizedImageURL: String {
        "https://picsum.photos/id/\(id)/300/200"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, author, url
        case downloadURL = "download_url"
    }
}


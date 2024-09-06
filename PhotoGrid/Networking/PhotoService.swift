//
//  PhotoService.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 06/09/2024.
//

import Alamofire
import Foundation

protocol PhotoServiceProtocol {
    func fetchPhotos(page: Int, completion: @escaping (Result<[PhotoModel], Error>) -> Void)
}

class PhotoService: PhotoServiceProtocol {
    
    func fetchPhotos(page: Int, completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
        let url = "\(Environment.baseURL)?page=\(page)&limit=21"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: [PhotoModel].self) { response in
            
            switch response.result {
                
            case .success(let photos):
                completion(.success(photos))
                
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
}

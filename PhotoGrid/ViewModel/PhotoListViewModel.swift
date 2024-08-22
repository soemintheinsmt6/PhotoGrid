//
//  PhotoListViewModel.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import Alamofire
import Foundation

class PhotoListViewModel {
    
    var photos: [PhotoModel] = []
    var onUpdate: (() -> Void)?
    
    var currentPage = 1
    private var isFetching = false
    
    func fetchPhotos() {
        guard !isFetching else { return }
        
        isFetching = true
        
        let url = "\(Environment.baseURL)?page=\(currentPage)&limit=21"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: [PhotoModel].self) { [weak self] response in
            DispatchQueue.global(qos: .background).async {
                switch response.result {
                    
                case .success(let photoList):
                    self?.photos.append(contentsOf: photoList)
                    self?.onUpdate?()
                    self?.currentPage += 1
                    
                case .failure(let error):
                    print("error fetching photos: \(error.localizedDescription)")
                }
                
                self?.isFetching = false
            }
        }
    }
}

//
//  PhotoListViewModel.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import Foundation

class PhotoListViewModel {
    private let photoService: PhotoServiceProtocol
    
    var photos: [PhotoModel] = []
    var onUpdate: (() -> Void)?
    
    var currentPage = 1
    private var isFetching = false
    
    init(photoService: PhotoServiceProtocol) {
        self.photoService = photoService
    }
    
    func fetchPhotos() {
        guard !isFetching else { return }
        isFetching = true
        
        photoService.fetchPhotos(page: currentPage) { [weak self] result in
            DispatchQueue.global(qos: .background).async {
                
                switch result {
                    
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

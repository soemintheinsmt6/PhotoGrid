//
//  PhotoListViewController.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import UIKit
import SkeletonView

class PhotoListViewController: UIViewController {
    
    let viewModel = PhotoListViewModel()
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
        viewModel.fetchPhotos()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCollectionViewItemSize()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate( alongsideTransition: { (_) in
            self.updateCollectionViewItemSize()
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupView() {
        title = "PhotoGrid"
        navigationController?.navigationBar.prefersLargeTitles = true
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        photoCollectionView.register(UINib(nibName: "IndicatorCell", bundle: nil), forCellWithReuseIdentifier: "indicatorCell")
        setupCollectionViewLayout()
        photoCollectionView.showAnimatedGradientSkeleton()
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.photoCollectionView.reloadData()
                
                guard let currentPage = self?.viewModel.currentPage else { return }
                guard currentPage < 3 else { return }
                self?.photoCollectionView.stopSkeletonAnimation()
                self?.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        }
    }
    
    private func setupCollectionViewLayout() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        photoCollectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
    }
    
    private func updateCollectionViewItemSize() {
        let numberOfColumns: CGFloat = 3
        let lineSpacing: CGFloat = 4
        let itemSpacing: CGFloat = 4
        
        let width = (photoCollectionView.frame.width - ((numberOfColumns - 1) * itemSpacing)) / numberOfColumns
        let height = width * 2 / 3 // 3:2
        
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
        collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
    }
}

extension PhotoListViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "photoCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count + 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < viewModel.photos.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
            let item = viewModel.photos[indexPath.row]
            cell.configure(with: item)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicatorCell", for: indexPath) as! IndicatorCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photos.count - 6 {
            viewModel.fetchPhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let downloadURL = viewModel.photos[indexPath.item].downloadURL
        pushPhotoDetailsViewController(image: downloadURL)
    }
    
}

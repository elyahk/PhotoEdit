//
//  PHAssetImageBridge.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 17/11/22.
//

import Photos
import UIKit

struct Photo: Hashable {
    var thumbnail: UIImage
    var asset: PHAsset
    
    func getHighQualityImage(completion: @escaping (UIImage?) -> Void) {
        let requestImageOption = PHImageRequestOptions()
        requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat

        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: requestImageOption) { (image:UIImage?, _) in
                completion(image)
         }
    }
}

class PHAssetImageBridge {
    let result: PHFetchResult<PHAsset>
    
    init(result: PHFetchResult<PHAsset>) {
        self.result = result
    }
    
    func getPhotos2(type: ImageResolutionType = .thumbnail(), completion: @escaping ([Photo]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            var photos: [Photo] = []
            
            switch type {
            case .thumbnail:
                for index in 0..<self.result.count {
                    let phAsset = self.result[index]
                    let image = self.getImage(from: phAsset, type: type)
                    let photo = Photo(thumbnail: image, asset: phAsset)
                    photos.append(photo)
                }
            }
            
            completion(photos)
        }
    }
    
    func getPhotos(type: ImageResolutionType = .thumbnail(), completion: @escaping ([UIImage]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            var photos: [UIImage] = []
            
            switch type {
            case .thumbnail:
                for index in 0..<self.result.count {
                    let phAsset = self.result[index]
                    photos.append(self.getImage(from: phAsset, type: type))
                }
            }
            
            completion(photos)
        }
    }
    
    private func getImage(from asset: PHAsset, type: ImageResolutionType) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        var size: CGSize = .zero
        
        switch type {
        case let .thumbnail(width, height):
            size = CGSize(width: 100.0, height: 100.0)
        }
        
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { image, info in
            thumbnail = image ?? UIImage()
        }
        return thumbnail
    }
}

extension PHAssetImageBridge {
    enum ImageResolutionType {
        case thumbnail(width: CGFloat = 100.0, height: CGFloat = 100.0)
    }
}

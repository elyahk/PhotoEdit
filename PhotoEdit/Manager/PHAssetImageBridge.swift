//
//  PHAssetImageBridge.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 17/11/22.
//

import Photos
import UIKit

class PHAssetImageBridge {
    let result: PHFetchResult<PHAsset>
    
    init(result: PHFetchResult<PHAsset>) {
        self.result = result
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
            size = CGSize(width: width, height: height)
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

//
//  File.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import PhotosUI

class PhotoLibraryManager {
    private var bridge: PHAssetImageBridge?
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            let result = self?.validateAuthorization(status: status) ?? false
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func hasAccessPhotos() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        let hasAccess = validateAuthorization(status: status)
        
        return hasAccess
    }
    
    func getPhotos(completion: @escaping ([Photo]) -> Void) {
        let result = fetchPhotosAssets()
        bridge = PHAssetImageBridge(result: result)
        bridge?.getPhotos { photos in
            completion(photos)
        }
    }
    
    func getHighQualityImage(for photo: Photo) async -> UIImage? {
        await withCheckedContinuation { continuation in
            photo.getHighQualityImage { highQualityImage in
                continuation.resume(returning: highQualityImage)
            }
        }
    }
    
    private func validateAuthorization(status: PHAuthorizationStatus) -> Bool {
        switch status {
        case .authorized:
            return true
            
        default:
            return false
        }
    }
    
    private func fetchPhotosAssets() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assets = PHAsset.fetchAssets(with: options)
        
        return assets
    }
}


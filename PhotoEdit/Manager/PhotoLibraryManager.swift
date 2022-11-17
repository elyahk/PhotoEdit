//
//  File.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import PhotosUI

class PhotoLibraryManager {
    
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
    
    private func validateAuthorization(status: PHAuthorizationStatus) -> Bool {
        switch status {
        case .authorized:
            return true
            
        default:
            return false
        }
    }
}


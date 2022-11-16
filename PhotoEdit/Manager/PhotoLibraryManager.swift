//
//  File.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import PhotosUI

class PhotoLibraryManager {
    func requestPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    completion(true)
                    
                default:
                    completion(false)
                }
            }
        }
    }
}


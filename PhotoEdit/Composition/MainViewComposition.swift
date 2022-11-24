//
//  File.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import SwiftUI

class MainViewComposition {
    private var manager = PhotoLibraryManager()
    
    func allowAccessView() -> some View {
        var view = AllowAccessView()
        view.events.requestPermission = { [weak self] completion in
            self?.manager.requestPermission { access in
                completion(access)
            }
        }
        
        return view
    }
    
    func galleryView2() -> GalleryView {
        var galleryView = GalleryView()
        galleryView.events.loadPhotos = {
            await withUnsafeContinuation { continuation in
                self.manager.getPhotos { photos in
                    DispatchQueue.main.async {
                        continuation.resume(returning: photos )
                    }
                }
            }
        }
            galleryView.events.filteredImages = { image in
                await ImageFilterManager.shared.getFilteredImages(image: image)
            }
            galleryView.events.highQuailityImage = { photo in
                await PhotoLibraryManager().getHighQualityImage(for: photo) ?? UIImage()

        }
        
        return galleryView
    }
    
    func hasAccess() -> Bool {
        manager.hasAccessPhotos()
    }
}

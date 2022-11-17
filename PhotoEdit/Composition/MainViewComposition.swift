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
    
    func galleryView() -> GalleryView {
        let galleryView = GalleryView(contentImages: [])
        manager.getPhotos { images in
            galleryView.contentImages = images
        }
        
        return galleryView
    }
    
    func hasAccess() -> Bool {
        manager.hasAccessPhotos()
    }
}

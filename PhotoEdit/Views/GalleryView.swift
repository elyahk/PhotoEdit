//
//  GalleryImageView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 17/11/22.
//

import SwiftUI
import Photos

struct GalleryView: View {
    var events: Events = .init()
    @State var photos: [Photo] = []
    @State private var presentImage: Bool = false
    @State var selectedPhoto: Photo = Photo(thumbnail: UIImage(), asset: PHAsset())
    
    private var columns = [
        GridItem(.flexible(), spacing: 2.0),
        GridItem(.flexible(), spacing: 2.0),
        GridItem(.flexible(), spacing: 2.0)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 2.0,
                    pinnedViews: []
                ) {
                    ForEach(photos, id: \.self) { photo in
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Image(uiImage: photo.thumbnail)
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipShape(Rectangle())
                            .onTapGesture {
                                selectedPhoto = photo
                                presentImage.toggle()
                            }
                    }
                }
            }
            .background(Color.black)
            .onAppear {
                events.loadPhotos { photos in
                    self.photos = photos
                }
            }
            .sheet(isPresented: $presentImage) {
                imageEditorView(photo: selectedPhoto)
            }
        }
    }
    
    func imageEditorView(photo: Photo) -> ImageEditorView {
        var view = ImageEditorView(photo: photo)
        view.events.filteredImages = { image in
            await ImageFilterManager.shared.getFilteredImages(image: image)
        }
        view.events.highQuailityImage = { photo in
            await PhotoLibraryManager().getHighQualityImage(for: photo) ?? UIImage()
        }
        
        return view
    }
}

// MARK: - GalleryView

extension GalleryView {
    struct Events {
        var loadPhotos: (@escaping ([Photo]) -> Void) -> Void = { _ in }
    }
}

struct GalleryView_Preview: PreviewProvider {
    static var previews: some View {
        galleryView()
    }
    
    static func galleryView() -> some View {
        var view = GalleryView()
        view.events.loadPhotos = { completion in
            completion(photos())
        }
        
        return view
    }
    
    static func photos() -> [Photo] {
        var assets: [Photo] = []
        
        for i in 0...10 {
            let image = UIImage(named: "image-\(i)")!
            assets.append(Photo(thumbnail: image, asset: PHAsset()))
        }
        
        return assets
    }
}

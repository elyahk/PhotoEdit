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
    @State var isLoading: Bool = true
    
    private var columns = [
        GridItem(.flexible(), spacing: 2.0),
        GridItem(.flexible(), spacing: 2.0),
        GridItem(.flexible(), spacing: 2.0)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 2.0,
                        pinnedViews: []
                    ) {
                        ForEach(photos, id: \.self) { photo in
                            NavigationLink {
                                imageEditorView(photo: photo)
                            } label: {
                                Rectangle()
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        Image(uiImage: photo.thumbnail)
                                            .resizable()
                                            .scaledToFill()
                                    )
                                    .clipShape(Rectangle())
                            }
                        }
                    }
                }
                .background(Color.black)
                .onAppear {
                    Task {
                        let photos = await events.loadPhotos()
                        self.photos = photos
                        isLoading.toggle()
                    }
                }
                
                VStack {
                    Spacer()
                    if isLoading {
                        Text("Loading...")
                            .foregroundColor(.white)
                            .font(.title)
                        LottieView(lottieFile: "pizza-animation")
                            .frame(width: .infinity, height: 300)
                    }
                    Spacer()
                }
            }
            .background(Color.black)
        }
    }
    
    func imageEditorView(photo: Photo) -> ImageEditorView {
        var view = ImageEditorView(photo: photo)
        view.events.filteredImages = events.filteredImages
        view.events.highQuailityImage = events.highQuailityImage
        
        return view
    }
}

// MARK: - GalleryView

extension GalleryView {
    struct Events {
        var loadPhotos: (() async -> [Photo]) = { [] }
        var filteredImages: ((UIImage) async -> [UIImage]) = { _ in [] }
        var highQuailityImage: ((Photo) async -> UIImage) = { _ in UIImage() }
    }
}

struct GalleryView_Preview: PreviewProvider {
    static var previews: some View {
        galleryView()
    }
    
    static func galleryView() -> some View {
        var view = GalleryView()
        view.events.loadPhotos = {
            await withUnsafeContinuation { continuation in
                continuation.resume(returning: photos())
            }
        }
        view.events.filteredImages = { _ in
            return photos().map { $0.thumbnail }
        }
        view.events.highQuailityImage = { $0.thumbnail }
        
        return view
    }
    
    static func photos() -> [Photo] {
        var assets: [Photo] = []
        
        for i in 1...11 {
            let image = UIImage(named: "image-\(i)")!
            assets.append(Photo(thumbnail: image, asset: PHAsset()))
        }
        
        return assets
    }
}

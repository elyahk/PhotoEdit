//
//  GalleryImageView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 17/11/22.
//

import SwiftUI
import Photos

class Gallery: ObservableObject {
    @Published var images: [UIImage] = []
}

struct GalleryView: View {
    var events: Events = .init()
    @State var photos: [Photo] = []
    @State private var presentImage: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    
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
                        NavigationLink {
                            ImageEditorView(photo: photo, image: photo.thumbnail)
                        }
                    label: {
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Image(uiImage: photo.thumbnail)
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipShape(Rectangle())
                            .sheet(isPresented: $presentImage) {
                                
                            }
                    }
                        
                    }
                }
            }
            .background(Color.black)
            .onAppear {
                events.loadPhotos2 { photos in
                    self.photos = photos
                }
            }
        }
    }
}

// MARK: - GalleryView

extension GalleryView {
    struct Events {
        var loadPhotos2: (@escaping ([Photo]) -> Void) -> Void = { _ in }
    }
}

struct GalleryView_Preview: PreviewProvider {
    static var previews: some View {
        galleryView()
            .environmentObject(Gallery())
    }
    
    static func galleryView() -> some View {
        var view = GalleryView()
        view.events.loadPhotos2 = { completion in
            completion(photos())
        }
        
        return view
    }
    
    static func photos() -> [Photo] {
        var assets: [Photo] = []
        
        for i in 0...11 {
            let image = UIImage(named: "image-\(i)")!
            assets.append(Photo(thumbnail: image, asset: PHAsset()))
        }
        
        return assets
    }
}

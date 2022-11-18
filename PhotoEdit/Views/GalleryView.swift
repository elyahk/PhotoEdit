//
//  GalleryImageView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 17/11/22.
//

import SwiftUI

class Gallery: ObservableObject {
    @Published var images: [UIImage] = []
}

struct GalleryView: View {
    var events: Events = .init()
    @State var images: [UIImage] = []
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
                    ForEach(images, id: \.self) { image in
                        NavigationLink {
                            Image(uiImage: image)
                        }
                    label: {
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Image(uiImage: image)
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
                events.loadPhotos { images in
                    self.images = images
                }
            }
        }
    }
}

// MARK: - GalleryView

extension GalleryView {
    struct Events {
        var loadPhotos: (@escaping ([UIImage]) -> Void) -> Void = { _ in }
    }
}

struct GalleryView_Preview: PreviewProvider {
    static var previews: some View {
        galleryView()
    }
    
    static func galleryView() -> some View {
        var view = GalleryView()
        view.events.loadPhotos = { completion in
            completion(images())
        }
        
        return view
    }
    
    static func images() -> [UIImage] {
        var assets: [UIImage] = []
        for i in 0...11 {
            assets.append(UIImage(named: "image-\(i)")!)
        }
        
        return assets
    }
}

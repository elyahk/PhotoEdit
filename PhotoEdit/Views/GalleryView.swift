//
//  GalleryImageView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 17/11/22.
//

import SwiftUI

struct GalleryView: View {
    @State var contentImages: [UIImage]
    @State private var presentImage: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    
    init(contentImages: [UIImage]) {
        self.contentImages = contentImages
    }
    
    private var columns = [
        GridItem(.flexible(), spacing: 2.0),
        GridItem(.flexible(), spacing: 2.0),
        GridItem(.flexible(), spacing: 2.0)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 2.0,
                pinnedViews: []
            ) {
                ForEach(contentImages, id: \.self) { image in
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .onTapGesture {
                                    selectedImage = image
                                    presentImage.toggle()
                                }
                        )
                        .clipShape(Rectangle())
                        .sheet(isPresented: $presentImage) {
                            Image(uiImage: selectedImage)
                        }
                }
            }
        }
        .background(Color.black)
    }
}

struct GalleryView_Preview: PreviewProvider {
   static var previews: some View {
        galleryView()
    }
    
    static func galleryView() -> some View {
        let view = GalleryView(contentImages: images())
        
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

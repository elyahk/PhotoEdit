//
//  ImageEditorView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 18/11/22.
//

import SwiftUI
import CoreImage
import Photos

struct ImageEditorView: View {
    @State var photo: Photo
    @State var filteredImages: [UIImage] = []
    @State var currentIndex = 0
    @State var highQualityImage: UIImage?
    
    var filterManager: ImageFilterManager
    
    init(photo: Photo, filterManager: ImageFilterManager) {
        self.photo = photo
        self.filterManager = filterManager
    }
    
    private var columns = [
        GridItem(.fixed(100), spacing: 2.0)
    ]
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView() {
                Image(uiImage: highQualityImage ?? photo.thumbnail)
                    .resizable()
                    .scaledToFit()
                    .padding([.top], 40)
                    .frame(maxWidth: .infinity)
            }
            Spacer()
            ScrollView(.horizontal) {
                LazyHGrid(
                    rows: columns,
                    alignment: .top,
                    spacing: 2.0,
                    pinnedViews: []
                ) {
                    ForEach(filteredImages, id: \.self) { filteredImage in
                        Image(uiImage: filteredImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.red)
                            .scaledToFit()
                            .onTapGesture {
                                self.highQualityImage = filteredImage
                            }
                    }
                }
                .frame(height: 100.0)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Title")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color.white)
                }
            }
            ToolbarItem(placement: .status) {
                Button {
                    
                } label: {
                    Image(systemName: "sun.min.fill")
                        .foregroundColor(Color.white)
                }
                
            }
            ToolbarItem(placement: .status) {
                Button {
                    
                } label: {
                    Image(systemName: "camera.filters")
                        .symbolRenderingMode(SwiftUI.SymbolRenderingMode.hierarchical)
                        .foregroundColor(Color.white)
                }
            }
            ToolbarItem(placement: .status) {
                Button {
                    
                } label: {
                    Image(systemName: "crop.rotate")
                        .foregroundColor(Color.white)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Text("Done")
                        .foregroundColor(Color.yellow)
                }
            }
        }
        .navigationTitle(
            Text("Filters")
        )
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.black)
        .onAppear {
            Task {
                await getHighQualityImage()
            }
        }
    }
    
    func getHighQualityImage() async {
        DispatchQueue.main.async {
            photo.getHighQualityImage { highQualityImage in
                guard let highQualityImage = highQualityImage else { return }
                
                self.highQualityImage = highQualityImage
                
                let filteredImages = filterManager.getFilteredImages(image: highQualityImage)
                
                DispatchQueue.main.async {
                    self.filteredImages = filteredImages
                }
            }
        }
    }
}

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
                ImageEditorView(
                    photo: Photo(thumbnail: UIImage(named: "image-1")!, asset: PHAsset()),
                    filterManager: ImageFilterManager.shared
                )
        }
    }
}

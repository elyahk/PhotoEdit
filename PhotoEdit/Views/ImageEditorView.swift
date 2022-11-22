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
    @State var image: UIImage
    @State var images: [UIImage] = []
    @State var currentIndex = 0
    
    init(photo: Photo, image: UIImage) {
        self.photo = photo
        self.image = image
    }
    
    private var columns = [
        GridItem(.fixed(100), spacing: 2.0)
    ]
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding([.top], 40)
                .frame(maxWidth: .infinity)
            Spacer()
            ScrollView(.horizontal) {
                LazyHGrid(
                    rows: columns,
                    alignment: .top,
                    spacing: 2.0,
                    pinnedViews: []
                ) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.red)
                            .onTapGesture {
                                self.image = image
                            }
                    }
                }
                .frame(height: 100.0)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .status) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
            }
            ToolbarItem(placement: .status) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
            }
            ToolbarItem(placement: .status) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Text("Done")
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
            photo.getHighQualityImage { image in
                guard let image = image else { return }
                
                DispatchQueue.main.async {
                    self.image = image
                }
                
                let images = FilterImage().getFilteredImages(image: image)
                
                DispatchQueue.main.async {
                    self.images = images
                }
            }
        }
    }
}

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ImageEditorView(photo: Photo(thumbnail: UIImage(named: "image-1")!, asset: PHAsset()),image: UIImage(named: "image-1")!)
        }
    }
}

class FilterImage {
    let context = CIContext()
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    func getFilteredImages(image: UIImage) -> [UIImage] {
        let images: [UIImage] = CIFilterNames.map {
            guard let filter = CIFilter(name: $0), let image = filterImage(image: image, filter: filter) else {
                return nil
            }
            
            return image
        }.compactMap { $0 }
        
        return images
    }
    
    func filterImage(image: UIImage, filter: CIFilter) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let result = filter.outputImage else { return nil}                        // 4
        let resultCGImage = context.createCGImage(result, from: result.extent)
        
        guard let cgImage = resultCGImage else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
//
//extension Photo {
//    func getHighQualityImage(complation: @escaping (UIImage?) -> Void) {
//        let requestImageOption = PHImageRequestOptions()
//        requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
//        
//        let manager = PHImageManager.default()
//        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: requestImageOption) { image, _ in
//            complation(image)
//        }
//    }
//}

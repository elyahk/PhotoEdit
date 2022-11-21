//
//  ImageEditorView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 18/11/22.
//

import SwiftUI
import CoreImage

struct ImageEditorView: View {
    @State var image: UIImage
    
    init(image: UIImage) {
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
            LazyHGrid(
                rows: columns,
                alignment: .top,
                spacing: 2.0,
                pinnedViews: []
            ) {
                ForEach(0...100, id: \.self) { id in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                }
            }
            .frame(height: 100.0)
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
            DispatchQueue.global().async {
                let newImage = FilterImage.filterImage(image: image)
                DispatchQueue.main.async {
                    self.image = newImage ?? UIImage(named: "image-3")!
                }
            }
        }
    }
}

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ImageEditorView(image: UIImage(named: "image-1")!)
        }
    }
}

class FilterImage {
    static func filterImage(image: UIImage) -> UIImage? {
            let context = CIContext()
            let filter = CIFilter(name: "CISepiaTone")!
            filter.setValue(0.8, forKey: kCIInputIntensityKey)
            let ciImage = CIImage(cgImage: image.cgImage!)
                                       // 3
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            let result = filter.outputImage!                               // 4
            let cgImage = context.createCGImage(result, from: result.extent)
            
            guard let cgImage = cgImage else {
                return nil
            }
            
            return UIImage(cgImage: cgImage)
    }
}

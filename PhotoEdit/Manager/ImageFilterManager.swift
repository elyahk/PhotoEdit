//
//  ImageFilterManager.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 23/11/22.
//

import UIKit
import CoreImage

class ImageFilterManager {
    static var shared = ImageFilterManager()
    
    private init() { }
    
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

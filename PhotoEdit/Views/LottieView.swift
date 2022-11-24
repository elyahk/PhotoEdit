//
//  File.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 24/11/22.
//

import SwiftUI
import Lottie
 
struct LottieView: UIViewRepresentable {
    let lottieFile: String
    let loopMode: LottieLoopMode
 
    let animationView = AnimationView()
    
    init(lottieFile: String, loopMode: LottieLoopMode = .loop) {
        self.lottieFile = lottieFile
        self.loopMode = loopMode
    }
 
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
 
        animationView.animation = Animation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.0
        animationView.loopMode = loopMode
        animationView.play()
 
        
        view.addSubview(animationView)
 
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        return view
    }
 
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

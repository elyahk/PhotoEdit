//
//  AllowAccessView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import SwiftUI

struct AllowAccessView: View {
    var events = Events()
    @State private var presentingModal = false
    
    var body: some View {
        VStack {
            Text("Give permission to your photos")
                .font(.title)
                .foregroundColor(.white)
                .padding([.top])
            Text("You need to give access to your photos to use this application and make the photos beautiful")
                .foregroundColor(.white)
                .font(.callout)
                .padding([.leading, .trailing])
                .padding(.top, 16)
            LottieView(lottieFile: "camera-access-animation", loopMode: .playOnce)
            Spacer()
            Button {
                events.requestPermission { access in
                    presentingModal.toggle()
                }
            } label: {
                Text("Allow Access")
                    .foregroundColor(Color.white)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background {
                        Rectangle()
                            .cornerRadius(8)
                    }
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom)
        }
        .background(Color.black)
        .fullScreenCover(isPresented: $presentingModal) {
            MainViewComposition().galleryView2()
        }
    }
}

struct AllowAccessView_Previews: PreviewProvider {
    static var previews: some View {
        AllowAccessView()
    }
}

// MARK: - Events

extension AllowAccessView {
    struct Events {
        var requestPermission: (@escaping (Bool) -> Void) -> Void = { _ in }
    }
}

//
//  AllowAccessView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import SwiftUI
import PhotosUI

class PhotoLibraryManager {
    func requestPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    completion(true)
                    
                default:
                    completion(false)
                }
            }
        }
    }
}

struct AllowAccessView: View {
    @State var presentingModal = false
    
    struct Events {
        var requestPermission: ((Bool) -> Void) -> Void = { _ in }
    }
    
    var events = Events()
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                presentingModal.toggle()
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
        .sheet(isPresented: $presentingModal) {
            ContentView()
        }
        
        
    }
}

struct AllowAccessView_Previews: PreviewProvider {
    static var previews: some View {
        AllowAccessView()
    }
}

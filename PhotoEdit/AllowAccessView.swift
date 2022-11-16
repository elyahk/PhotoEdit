//
//  AllowAccessView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import SwiftUI

struct AllowAccessView: View {
    var body: some View {
        VStack {
            Spacer()
            Button {
                print("Tapped")
            } label: {
                Text("Allow Access")
                    .foregroundColor(Color.white)
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
        
    }
}

struct AllowAccessView_Previews: PreviewProvider {
    static var previews: some View {
        AllowAccessView()
    }
}

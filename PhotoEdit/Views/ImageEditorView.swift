//
//  ImageEditorView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 18/11/22.
//

import SwiftUI

struct ImageEditorView: View {
    @State var image: UIImage = UIImage(named: "image-1")!
    
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
    }
}


struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ImageEditorView()
        }
    }
}

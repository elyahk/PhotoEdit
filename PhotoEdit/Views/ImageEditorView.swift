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
    var events: Events = .init()
    @State var photo: Photo
    @State var filteredImages: [UIImage] = []
    @State var currentIndex = 0
    @State var highQualityImage: UIImage?
    
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    private var columns = [
        GridItem(.fixed(50), spacing: 2.0)
    ]
    
    var body: some View {
        VStack {
            ZoomableScrollView {
                Image(uiImage: highQualityImage ?? photo.thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.never)
            
            
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
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                            .scaledToFit()
                            .onTapGesture {
                                self.highQualityImage = filteredImage
                            }
                    }
                }
                .frame(height: 50)
                
                Spacer()
                    .frame(height: 50.0)
            }
            .scrollIndicators(.never)
            .padding([.bottom, .top])
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
                let image = try await events.highQuailityImage(photo)
                self.highQualityImage = image
                let filteredImages = await events.filteredImages(image)
                self.filteredImages =  filteredImages
            }
        }
    }
    
    struct Events {
        var highQuailityImage: ((Photo) async throws -> UIImage) = { _ in return UIImage() }
        var filteredImages: ((UIImage) async -> [UIImage]) = { _ in return [] }
    }
}

struct ImageEditorView_Previews: PreviewProvider {
    static func getView() -> ImageEditorView {
        var view = ImageEditorView(
            photo: Photo(thumbnail: UIImage(named: "image-1")!, asset: PHAsset())
        )
        view.events.highQuailityImage = { _ in return UIImage(named: "image-1")!}
        view.events.filteredImages = { image in return [
            UIImage(named: "image-1")!,
            UIImage(named: "image-2")!,
            UIImage(named: "image-3")!,
            UIImage(named: "image-4")!,
            UIImage(named: "image-5")!,
            UIImage(named: "image-6")!,
            UIImage(named: "image-7")!,
            UIImage(named: "image-8")!,
            UIImage(named: "image-9")!,
            UIImage(named: "image-10")!
        ] }
        
        return view
    }
    
    static var previews: some View {
        NavigationStack {
            getView()
        }
    }
}

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
  private var content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = 20
    scrollView.minimumZoomScale = 1
    scrollView.bouncesZoom = true
    scrollView.backgroundColor = .clear

    // create a UIHostingController to hold our SwiftUI content
    let hostedView = context.coordinator.hostingController.view!
    hostedView.backgroundColor = .clear
    hostedView.translatesAutoresizingMaskIntoConstraints = true
    hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    hostedView.frame = scrollView.bounds
    scrollView.addSubview(hostedView)

    return scrollView
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(hostingController: UIHostingController(rootView: self.content))
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
    // update the hosting controller's SwiftUI content
    context.coordinator.hostingController.rootView = self.content
    assert(context.coordinator.hostingController.view.superview == uiView)
  }

  // MARK: - Coordinator

  class Coordinator: NSObject, UIScrollViewDelegate {
    var hostingController: UIHostingController<Content>

    init(hostingController: UIHostingController<Content>) {
      self.hostingController = hostingController
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return hostingController.view
    }
  }
}

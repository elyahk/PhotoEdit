//
//  PhotoEditApp.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import SwiftUI

@main
struct PhotoEditApp: App {
    let mainViewComposition = MainViewComposition()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if !mainViewComposition.hasAccess() {
                mainViewComposition.allowAccessView()
            } else {
//                ImageEditorView()
                mainViewComposition.galleryView2()
                    .environmentObject(Gallery())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

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
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

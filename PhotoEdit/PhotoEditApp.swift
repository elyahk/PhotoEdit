//
//  PhotoEditApp.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 16/11/22.
//

import SwiftUI

@main
struct PhotoEditApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AllowAccessView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

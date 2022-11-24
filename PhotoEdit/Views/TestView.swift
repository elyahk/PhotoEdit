//
//  TestView.swift
//  PhotoEdit
//
//  Created by Eldorbek Nusratov on 21/11/22.
//

import SwiftUI

struct TestView: View {
    @State var state = 0
    
    var body: some View {
        VStack {
            Text("State: \(state)")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

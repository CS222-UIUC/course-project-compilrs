//
//  LandingView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct LandingView: View {
    @ObservedObject var model = MatrixObject([[0, 0], [0, 0]])
    var body: some View {
        NavigationView {
            List {
                Text("Matrices")
                    .navLink {
                        MatrixSolveView()
                            .environmentObject(model)
                    }
            }
        }
        .navigationBarTitle("Home")
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}

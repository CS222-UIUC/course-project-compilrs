//
//  LandingView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Matrices")
                    .navLink(MatrixSolveView())
                    .padding(15)
                Text("Integrals")
                    .navLink(IntegralSolveView())
                    .padding(15)
            }
        }
        .navigationTitle("Home")
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}

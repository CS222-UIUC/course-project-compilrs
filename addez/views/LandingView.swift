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
                NavigationLink(destination: MatrixSolveView()) {
                    Text("Matrices")
                }
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

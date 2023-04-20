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
            ScrollView {
                GeometryReader { geometry in
                    Text("Matrices")
                        .tiled()
                        .navLink(MatrixSolveView())
                        .padding(15)
                        .shadow(radius: 10)
                        .rotation3DEffect(Angle(degrees: (geometry.frame(in: .global).minY - 10) / 90.0), axis: (x: 2.0, y: 0.0, z: 0))
                }
                .frame(height: 300)
                GeometryReader { geometry in
                    Text("Integrals")
                        .tiled()
                        .navLink(IntegralSolveView())
                        .padding(15)
                        .shadow(radius: 10)
                        .rotation3DEffect(Angle(degrees: (geometry.frame(in: .global).minY - 10) / 90.0), axis: (x: 2.0, y: 0.0, z: 0))
                }
                .frame(height: 300)
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

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
                        .cardView(.canvas)
                        .navLink(MatrixSolveView())
                        .padding(15)
                        .shadow(radius: 10)
                        .rotation3DEffect(Angle(degrees: (geometry.frame(in: .global).minY - 10) / 50.0), axis: (x: 10.0, y: 0.0, z: 0))
                }
                .frame(height: 300)
                GeometryReader { geometry in
                    Text("Integrals")
                        .cardView(.canvas)
                        .navLink(IntegralSolveView())
                        .padding(15)
                        .shadow(radius: 10)
                        .rotation3DEffect(Angle(degrees: (geometry.frame(in: .global).minY - 10) / 50.0), axis: (x: 10.0, y: 0.0, z: 0))
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

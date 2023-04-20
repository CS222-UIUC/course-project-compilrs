//
//  UITools.swift
//  addez
//
//  Created by Ayush Raman on 3/9/23.
//

import SwiftUI

extension Color {
    static let background = Color("BackgroundColor")
    static let matrixCell = Color("MatrixCell")
    static let canvas = Color("Canvas")
    
    func inverse() -> Color {
        guard let components = UIColor(self).cgColor.components else { return Color.accentColor }
        return Color(red: 1 - components[0], green: 1 - components[1], blue: 1 - components[2])
    }
}

extension View {
    func format() -> AnyView { AnyView(self) }
    
    func navLink(_ destination: () -> AnyView?) -> AnyView {
        guard let destination = destination() else { return Button(action: {}, label: { self }).disabled(true).format() }
        return NavigationLink(destination: { destination }, label: { self })
            .format()
    }
    
    func navLink(_ destination: some View) -> AnyView {
        NavigationLink(destination: { destination }, label: { self })
            .format()
    }
    
    func celled(_ color: Color? = .none) -> some View {
        self
            .padding(1)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(color ?? .matrixCell, lineWidth: 2)
            )
    }
}

extension Formatter {
    static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}

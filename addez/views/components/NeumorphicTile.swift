//
//  NeumorphicTile.swift
//  addez
//
//  Created by Ayush Raman on 4/20/23.
//

import SwiftUI

extension View {
    func tiled() -> NeumorphicTile {
        NeumorphicTile() {
            self
        }
    }
}

struct NeumorphicTile: View {
    var view: () -> any View
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(colors: [.gray, .white, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(radius: 8, x: 30, y: 20)
            view().format()
        }
        .frame(height: 240)
    }
}

struct NeumorphicTile_Previews: PreviewProvider {
    static var previews: some View {
        NeumorphicTile() {
            Text("Hello World!")
        }
    }
}

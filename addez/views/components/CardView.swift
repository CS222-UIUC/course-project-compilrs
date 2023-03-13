//
//  CardView.swift
//  addez
//
//  Created by Ayush Raman on 3/9/23.
//

import SwiftUI

extension View {
    func cardView(_ color: Color = Color("BackgroundColor")) -> CardView {
        CardView(color: color) {
           AnyView(self)
        }
    }
}
struct CardView: View {
    var color: Color = .background
    var view: () -> any View
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .shadow(color: .background, radius: 8)
            view()
                .format()
        }
        .frame(height: 240)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView() {
            Text("Hello World!")
                .bold()
                .format()
        }
    }
}

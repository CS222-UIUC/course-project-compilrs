//
//  MatrixView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct MatrixView: View {
    var matrix: Matrix?
    init(_ matrix: Matrix?) {
        self.matrix = matrix
    }
    var body: some View {
        Grid {
            
        }
    }
}

struct MatrixView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixView(Matrix([[]]))
    }
}

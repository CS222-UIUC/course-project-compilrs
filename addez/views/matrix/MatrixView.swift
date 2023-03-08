//
//  MatrixView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct MatrixView: View {
    var matrix: Matrix
    init(_ matrix: Matrix) {
        self.matrix = matrix
    }
    var body: some View {
        VStack {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        Text("\(matrix[row][col], specifier: "%.2f")")
                    }
                }
            }
        }
    }
}

struct MatrixView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixView(Matrix([[0, 1], [1, 0]]))
    }
}

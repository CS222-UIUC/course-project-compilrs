//
//  MatrixView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct MatrixView: View {
    var matrix: Matrix
    var title: String?
    init(_ matrix: Matrix, title: String? = .none) {
        self.matrix = matrix
        self.title = title
    }
    var body: some View {
        VStack {
            viewLet(title, to: Text.init)
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        Text("\(matrix[row][col], specifier: "%.2f")")
                            .celled()
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

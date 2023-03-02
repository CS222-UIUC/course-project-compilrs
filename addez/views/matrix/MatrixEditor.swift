//
//  MatrixEditor.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct MatrixEditor: View {
    @State var matrix: Matrix
    init(_ matrix: Matrix) {
        self.matrix = matrix
    }
    var body: some View {
        VStack {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        TextField(
                            "0",
                            value: Binding<Double>(get: { matrix[row][col]
                            }, set: { value in
                                matrix[row][col] = value
                            }),
                            formatter: NumberFormatter()
                        )
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}

struct MatrixEditor_Previews: PreviewProvider {
    static var previews: some View {
        MatrixEditor(getMatrix(width: 8, height: 8))
    }
}

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
        HStack {
            Button(action: {
                guard matrix[0].count > 1 else {
                    return
                }
                matrix = matrix.map {
                    $0.dropLast()
                }
            }) {
                Image(systemName: "minus")
                    .imageScale(.small)
            }
            .softButtonStyle(Capsule())
            .padding(5)
            .disabled(matrix[0].count <= 1)
            VStack {
                Button(action: {
                    guard matrix.count > 1 else {
                        return
                    }
                    matrix = matrix.dropLast()
                }) {
                    Image(systemName: "minus")
                        .imageScale(.small)
                }
                .softButtonStyle(Capsule())
                .padding(5)
                .disabled(matrix.count <= 1)
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
                Button(action: { matrix.append(Array(repeating: 0, count: matrix[0].count))
                }) {
                    Image(systemName: "plus")
                        .imageScale(.small)
                }
                .softButtonStyle(Capsule())
                .padding(5)
                .disabled(matrix.count >= 8)
            }
            Button(action: {
                matrix = matrix.map {
                    $0 + [0]
                }
            }) {
                Image(systemName: "plus")
                    .imageScale(.small)
            }
            .softButtonStyle(Capsule())
            .padding(5)
            .disabled(matrix[0].count >= 8)
        }
        .padding(10)
    }
}

struct MatrixEditor_Previews: PreviewProvider {
    static var previews: some View {
        MatrixEditor(getMatrix(width: 8, height: 8))
    }
}

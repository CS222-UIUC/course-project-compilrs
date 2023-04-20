//
//  MatrixEditor.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct MatrixEditor: View {
    @EnvironmentObject var model: MatrixObject
    var body: some View {
        HStack {
            Button(action: {
                guard model.cols > 1 else { return }
                model.matrix = model.matrix.map { $0.dropLast() }
            }) {
                Image(systemName: "minus")
                    .imageScale(.small)
            }
            .softButtonStyle(Capsule())
            .padding(5)
            .disabled(model.cols <= 1)
            VStack {
                Button(action: {
                    guard model.rows > 1 else { return }
                    model.matrix = model.matrix.dropLast()
                }) {
                    Image(systemName: "minus")
                        .imageScale(.small)
                }
                .softButtonStyle(Capsule())
                .padding(5)
                .disabled(model.rows <= 1)
                VStack {
                    ForEach(0..<model.rows, id: \.self) { row in
                        HStack {
                            ForEach(0..<model.cols, id: \.self) { col in
                                TextField(
                                    "0",
                                    value: Binding<Double>(get: {
                                        guard row < model.rows && col < model.cols else { return 0 }
                                        return model.matrix[row][col]
                                    }, set: { value in
                                        guard row < model.rows && col < model.cols else { return }
                                        model.matrix[row][col] = value
                                    }),
                                    formatter: .numberFormatter
                                )
                                .celled(model.matrix[row][col] == 0 ? .red.opacity(0.2) : .none)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                Button(action: {
                    guard model.rows < Matrix.maxDimensions.rows else { return }
                    model.matrix.append(Array(repeating: 0, count: model.cols))
                }) {
                    Image(systemName: "plus")
                        .imageScale(.small)
                }
                .softButtonStyle(Capsule())
                .padding(5)
                .disabled(model.rows >= Matrix.maxDimensions.rows)
            }
            Button(action: {
                guard model.cols < Matrix.maxDimensions.cols else { return }
                model.matrix = model.matrix.map { $0 + [0] }
            }) {
                Image(systemName: "plus")
                    .imageScale(.small)
            }
            .softButtonStyle(Capsule())
            .padding(5)
            .disabled(model.cols >= Matrix.maxDimensions.cols)
        }
        .padding(10)
        .animation(.easeInOut(duration: 0.3), value: model.rows + model.cols)
    }
}

struct MatrixEditor_Previews: PreviewProvider {
    static var matrix = getMatrix(cols: 6, rows: 6)
    static var previews: some View {
        MatrixEditor()
            .environmentObject(MatrixObject(matrix))
    }
}

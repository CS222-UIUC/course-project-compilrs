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
                guard model.matrix[0].count > 1 else { return }
                model.matrix = model.matrix.map { $0.dropLast() }
            }) {
                Image(systemName: "minus")
                    .imageScale(.small)
            }
            .softButtonStyle(Capsule())
            .padding(5)
            .disabled(model.matrix[0].count <= 1)
            VStack {
                Button(action: {
                    guard model.matrix.count > 1 else {
                        return
                    }
                    model.matrix = model.matrix.dropLast()
                }) {
                    Image(systemName: "minus")
                        .imageScale(.small)
                }
                .softButtonStyle(Capsule())
                .padding(5)
                .disabled(model.matrix.count <= 1)
                VStack {
                    ForEach(0..<model.matrix.count, id: \.self) { row in
                        HStack {
                            ForEach(0..<model.matrix[row].count, id: \.self) { col in
                                TextField(
                                    "0",
                                    value: Binding<Double>(get: {
                                        model.matrix[row][col]
                                    }, set: { value in
                                        model.matrix[row][col] = value
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
                Button(action: { model.matrix.append(Array(repeating: 0, count: model.matrix[0].count))
                }) {
                    Image(systemName: "plus")
                        .imageScale(.small)
                }
                .softButtonStyle(Capsule())
                .padding(5)
                .disabled(model.matrix.count >= 8)
            }
            Button(action: {
                model.matrix = model.matrix.map {
                    $0 + [0]
                }
            }) {
                Image(systemName: "plus")
                    .imageScale(.small)
            }
            .softButtonStyle(Capsule())
            .padding(5)
            .disabled(model.matrix[0].count >= 8)
        }
        .padding(10)
    }
}

struct MatrixEditor_Previews: PreviewProvider {
    static var previews: some View {
        MatrixEditor()
            .environmentObject(MatrixObject(getMatrix(width: 8, height: 8)))
    }
}

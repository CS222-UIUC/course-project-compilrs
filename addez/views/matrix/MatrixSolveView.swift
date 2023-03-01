//
//  MatrixSolveView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI
import Neumorphic

struct MatrixSolveView: View {
    @State var matrixFunction: MatrixFunctions = .solve
    @State var matrix: Matrix = [[0, 0], [0, 0]]
    @State var steps: [Step]?
    @State var solution: SolutionType?
    var body: some View {
        VStack {
            Picker(selection: $matrixFunction, label: Text("Picker")) {
                ForEach(MatrixFunctions.allCases, id:\.rawValue) { fun in
                    Text(fun.rawValue).tag(fun)
                }
            }
            .pickerStyle(MenuPickerStyle())
            HStack {
                Button(action: {
                    matrix = matrix.map {
                        $0.dropLast()
                    }
                }) {
                    Image(systemName: "minus")
                        .imageScale(.small)
                }
                .softButtonStyle(Capsule())
                .padding(5)
                VStack {
                    Button(action: {
                        matrix = matrix.map {
                            $0.dropLast()
                        }
                    }) {
                        Image(systemName: "minus")
                            .imageScale(.small)
                    }
                    .softButtonStyle(Capsule())
                    .padding(5)
                    MatrixEditor(matrix)
                    Button(action: {
                        matrix = matrix.map {
                            $0.dropLast()
                        }
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.small)
                    }
                    .softButtonStyle(Capsule())
                    .padding(5)
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
            }
                .padding(10)
            MatrixView(steps?.last?.0 ?? Matrix())
            Button("Solve") {
                let sol = matrixFunction.getFunc()(matrix)
                steps = sol?.0
                solution = sol?.1
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: 20), pressedEffect: .hard)
            .fontWeight(.bold)
        }
        .navigationTitle("Matrix Solver")
        .background(Color("BackgroundColor"))
    }
}

struct MatrixSolveView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixSolveView()
    }
}

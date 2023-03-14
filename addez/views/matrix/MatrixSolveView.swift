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
                ForEach(MatrixFunctions.allCases, id:\.rawValue) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            MatrixEditor(matrix)
            Text("Show Steps")
                .navLink(StepsList(steps ?? []))
            solView().format()
            Button("Solve") {
                let sol = matrixFunction.getFunc()(matrix)
                steps = sol?.0
                solution = sol?.1
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: 20), pressedEffect: .hard)
                .fontWeight(.bold)
        }
        .navigationBarTitle("Matrix Solver")
    }
    
    func solView() -> any View {
        guard let sol = solution else { return EmptyView() }
        return SolutionView(sol)
    }
}

struct MatrixSolveView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixSolveView()
    }
}

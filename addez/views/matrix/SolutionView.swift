//
//  SolutionView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI
import LaTeXSwiftUI

struct SolutionView: View {
    var solution: SolutionType
    init(_ solution: SolutionType) {
        self.solution = solution
    }
    var body: some View {
        switch solution {
        case .matrix(let matrix): return MatrixView(matrix).cardView()
        case .double(let num): return Text("\(num, specifier: "%.2f")").cardView()
        case .matrixTuple(let lower, let upper): return HStack {
            MatrixView(lower, title: "Lower")
            Divider()
            MatrixView(upper, title: "Upper")
        }
        .padding(15)
        .cardView()
        case .ntuple(let ntuple): return VStack {
            ForEach(ntuple, id: \.self) { arg in
                LaTeX(arg)
                    .celled()
            }
        }
        .cardView()
        case .vector(let vec): return Text("").cardView()
        }
    }
}

struct MatrixSolutionPreview: PreviewProvider {
    static var previews: some View {
        SolutionView(.matrix([[1, 0], [1, 0]]))
    }
}

struct DoubleSolutionPreview: PreviewProvider {
    static var previews: some View {
        SolutionView(.double(2.0))
    }
}

struct MatrixTupleSolutionPreview: PreviewProvider {
    static var previews: some View {
        SolutionView(.matrixTuple(lower: [[1, 0], [1, 0]], upper: [[1, 9], [0, 0]]))
    }
}

struct NTupleSolutionPreview: PreviewProvider {
    static var previews: some View {
        SolutionView(.ntuple(["x = ss", "y = ss", "z = ss"]))
    }
}

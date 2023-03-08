//
//  StepsList.swift
//  addez
//
//  Created by Ayush Raman on 3/8/23.
//

import SwiftUI
import LaTeXSwiftUI

struct StepsList: View {
    let steps: [Step]
    init(_ steps: [Step]) {
        self.steps = steps
    }
    var body: some View {
        List {
            ForEach (steps) { step in
                HStack {
                    LaTeX(step.stepDescription)
                    Spacer()
                    MatrixView(step.matrix)
                }
            }
        }
    }
}

struct StepsList_Previews: PreviewProvider {
    static var previews: some View {
        let steps = [
            Step(matrix: [[0, 1, 2], [0, 4, 2]], stepDescription: "$R1 \\iff R2$"),
            Step(matrix: [[0, 1, 2], [0, 4, 2]], stepDescription: "$R1 \\implies R1 \\cdot  2R2$"),
            Step(matrix: [[0, 1, 2], [0, 4, 2]], stepDescription: "$R1 \\implies R1 \\cdot  2R2$")
        ]
        return StepsList(steps)
    }
}

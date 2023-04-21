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
        ScrollView {
            ForEach (steps) { step in
                GeometryReader { geometry in
                    CardView() {
                        VStack {
                            LaTeX(step.stepDescription)
                            MatrixView(step.matrix)
                        }
                        .padding(15)
                    }
                    .padding(15)
                    .shadow(radius: 10)
                    .rotation3DEffect(Angle(degrees: (geometry.frame(in: .global).minY - 10) / 50.0), axis: (x: 10.0, y: 0.0, z: 0))
                }
                .frame(height: 300)
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

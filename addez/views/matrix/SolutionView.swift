//
//  SolutionView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI

struct SolutionView: View {
    var solution: SolutionType
    init(_ solution: SolutionType) {
        self.solution = solution
    }
    var body: some View {
        getView()
    }
    func getView() -> AnyView {
        switch solution {
        case .matrix(let matrix): return AnyView(MatrixView(matrix))
        case .double(let num): return AnyView(Text("\(num.rounded())"))
        default: return AnyView(Text(""))
        }
    }
}

struct SolutionView_Previews: PreviewProvider {
    static var previews: some View {
        SolutionView(.matrix([[1, 0], [1, 0]]))
    }
}

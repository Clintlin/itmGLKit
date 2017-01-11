//
//  triangleModel.swift
//  itmGLKit
//
//  Created by ClintLin on 2017/1/10.
//  Copyright © 2017年 ClintLin. All rights reserved.
//

import GLKit

class triangleModel: itmModel {

    let vertexList : [Vertex] = [
        Vertex( 1.0, -1.0, 0, 1.0, 0.0, 0.0, 1.0),
        Vertex( 1.0,  1.0, 0, 0.0, 1.0, 0.0, 1.0),
        Vertex(-1.0,  1.0, 0, 0.0, 0.0, 1.0, 1.0),
        Vertex(-1.0, -1.0, 0, 1.0, 1.0, 0.0, 1.0)
    ]

    let indexList : [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]

    init(shader: itmShader) {
        super.init(name: "triangle", shader: shader, vertices: vertexList, indices: indexList)
    }
}

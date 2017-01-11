//
//  ViewController.swift
//  itmGLKit
//
//  Created by ClintLin on 2017/1/9.
//  Copyright © 2017年 ClintLin. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {

    var glkView: GLKView!
    var vertexBuffer : GLuint = 0
    var shader : itmShader!
    var triangle: triangleModel!
    var vao: GLuint = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupGLcontext()
        setupScene()
 
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        self.triangle.render()
    }
    
}

extension ViewController {
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let pt = touch.location(in: self.view)
//    }
}


extension ViewController {
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glkView.context)
    }
    
    func setupScene() {
        
        let attributeNames = NSArray(objects: "a_Position","a_Color")
//        let uniformNames = ["Position","Color"]
        self.shader = itmShader(vertexShader: "SimpleVertexShader.glsl",
                                fragmentShader: "SimpleFragmentShader.glsl",
                                attributeNames:attributeNames,
                                uniformNames :nil)
        self.triangle = triangleModel(shader: self.shader)
    }
    
    
}


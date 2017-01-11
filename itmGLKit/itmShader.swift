//
//  itmShader.swift
//  itmGLKit
//
//  Created by ClintLin on 2017/1/9.
//  Copyright © 2017年 ClintLin. All rights reserved.
//

import GLKit

class itmShader {
    var programHandle : GLuint = 0
    var uniforms_ : NSMutableDictionary = NSMutableDictionary()
    init(vertexShader: String, fragmentShader: String,  attributeNames:NSArray? , uniformNames :Array<String>?) {
        self.compile(vertexShader: vertexShader, fragmentShader: fragmentShader,attributeNames: attributeNames, uniformNames: uniformNames)
    }
    
    func prepareToDraw() {
        glUseProgram(self.programHandle)
    }
}

extension itmShader {
    func compileShader(_ shaderName: String, shaderType: GLenum) -> GLuint {
        let path = Bundle.main.path(forResource: shaderName, ofType: nil)
        
        do {
            
            // swift在编译的时候，需要转换数据类型.
            // 我们先分解这部分
            let shaderString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            let shaderHandle = glCreateShader(shaderType)
            var shaderStringLength : GLint = GLint(Int32(shaderString.length))
            var shaderCString = shaderString.utf8String! as UnsafePointer<GLchar>?
            glShaderSource(
                shaderHandle,
                GLsizei(1),
                &shaderCString,
                &shaderStringLength)
            
            glCompileShader(shaderHandle)
            var compileStatus : GLint = 0
            glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus)
            
            if compileStatus == GL_FALSE {
                var infoLength : GLsizei = 0
                let bufferLength : GLsizei = 1024
                glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
                
                let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
                var actualLength : GLsizei = 0
                
                glGetShaderInfoLog(shaderHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
                NSLog(String(validatingUTF8: info)!)
                exit(1)
            }
            
            return shaderHandle
            
        } catch {
            exit(1)
        }
    }
    
    func compile(vertexShader: String, fragmentShader: String, attributeNames: NSArray? , uniformNames :Array<String>? ) {
        let vertexShaderName = self.compileShader(vertexShader, shaderType: GLenum(GL_VERTEX_SHADER))
        let fragmentShaderName = self.compileShader(fragmentShader, shaderType: GLenum(GL_FRAGMENT_SHADER))
        
        self.programHandle = glCreateProgram()
        glAttachShader(self.programHandle, vertexShaderName)
        glAttachShader(self.programHandle, fragmentShaderName)
        
        
        // bind attribute locations; 必须在link之前执行
        attributeNames?.enumerateObjects({ (obj, idx, stop) in
            if let name = obj as? String {
                glBindAttribLocation(self.programHandle, GLuint(idx), name.cString(using: String.Encoding.utf8))
            }
        })
        
        // link program
        if (linkProgram(self.programHandle) == GL_FALSE){
            fatalError("self.programHandle link error")
        }
        
        //
        if let uniformNames_ = uniformNames {
            let uniformMap = NSMutableDictionary(capacity: uniformNames_.count)
            
            for name in uniformNames_ {
                let location = glGetUniformLocation(self.programHandle, name.cString(using: String.Encoding.utf8))
                uniformMap[name] = NSNumber(value: location)
            }
            self.uniforms_ = uniformMap
        }
        
        
        //
        var linkStatus : GLint = 0
        glGetProgramiv(self.programHandle, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE {
            var infoLength : GLsizei = 0
            let bufferLength : GLsizei = 1024
            glGetProgramiv(self.programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            
            let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            var actualLength : GLsizei = 0
            
            glGetProgramInfoLog(self.programHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
            NSLog(String(validatingUTF8: info)!)
            exit(1)
        }
        
        // release vertex and fragment shaders
        if (vertexShaderName != 0) {
            glDeleteShader(vertexShaderName);
        }
        if (fragmentShaderName != 0) {
            glDeleteShader(fragmentShaderName);
        }
        
        
    }
    
    func location(forKey key:String)->GLuint {
        
        if let location = self.uniforms_.value(forKey: key) as? NSNumber{
            return GLuint(location.int32Value)
        }
        
        return 0
    }

    func linkProgram(_ prog:GLuint)->GLint {
        
        glLinkProgram(prog);
        
        var status:GLint = 0
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status);
        if (status == GL_FALSE){
            print("Failed to link program %d", prog);
        }
        return status
    }

}

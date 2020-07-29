//
//  shaderPrimer.swift
//  anotherShaderTest
//
//  Created by DM on 9/11/16.
//  Copyright © 2016 DM. All rights reserved.
//

import SceneKit

class shaderPrimer: NSObject{

    override init() {
        super.init()
    }
    
    /// -Returns: SCNMaterial object with shader snippets applied
    func createMaterialWithShaders(_ geometry: String = "", surface: String = "", lighting: String = "", fragment: String = "") ->SCNMaterial {
        //works on .shader files only in the shader folder. Back face culling enabled
        let newMaterial = SCNMaterial()
        
        var shaders = [SCNShaderModifierEntryPoint : String]()
        var path = ""
        
        if geometry != "" {
            path = Bundle.main.path(forResource: geometry, ofType: "shader", inDirectory: "art.scnassets/shaders")!
            
            do{
                let newShader = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                shaders[SCNShaderModifierEntryPoint.geometry] = newShader
                
            }catch let error as NSError{
                print(error.description)
            }
        }
        
        if surface != "" {
            path = Bundle.main.path(forResource: surface, ofType: "shader", inDirectory: "art.scnassets/shaders")!
            
            do{
                let newShader = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                shaders[SCNShaderModifierEntryPoint.surface] = newShader
                
            }catch let error as NSError{
                print(error.description)
            }
        }
        
        if lighting != "" {
            path = Bundle.main.path(forResource: lighting, ofType: "shader", inDirectory: "art.scnassets/shaders")!
            
            do{
                let newShader = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                shaders[SCNShaderModifierEntryPoint.lightingModel] = newShader
                
            }catch let error as NSError{
                print(error.description)
            }
        }
        
        if fragment != "" {
            path = Bundle.main.path(forResource: fragment, ofType: "shader", inDirectory: "art.scnassets/shaders")!
            
            do{
                let newShader = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                shaders[SCNShaderModifierEntryPoint.fragment] = newShader
                
            }catch let error as NSError{
                print(error.description)
            }
        }
        
        newMaterial.shaderModifiers = shaders
        newMaterial.cullMode = SCNCullMode.back
        
        return newMaterial
    }
    
}

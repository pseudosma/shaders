//
//  mangaShaderPrimer.swift
//  yetyetAnotherShaderTest
//
//  Created by DM on 5/10/17.
//  Copyright © 2017 DM. All rights reserved.
//

import SceneKit


class mangaShaderPrimer: shaderPrimer {
    
        enum mangaShadingScheme: Int {
        case solidSingleShadow = 0
        case dottedSingleShadow = 1
        case hatchedSingleShadow = 2
        case hatchedAndDottedSingleShadow = 3
        case solidDoubleShadow = 4
        case hatchedDoubleShadow = 5
        case hatchedAndDottedDoubleShadow = 6
    }
    
    var diffuseTextureName: String
    var reflectiveTextureName: String
    var shadingScheme: mangaShadingScheme
    var textureDimensions: CGPoint
    
    
    override init() {
        shadingScheme = mangaShadingScheme.solidSingleShadow
        diffuseTextureName = ""
        reflectiveTextureName = ""
        textureDimensions = CGPoint.zero
        super.init()
    }
    
    /// Override specific for manga shader set.
    /// - Returns: SCNMaterial
    override func createMaterialWithShaders(_ geometry: String = "", surface: String = "", lighting: String = "", fragment: String = "") ->SCNMaterial {
        //works on .shader files only in the shader folder. Back face culling enabled
        let newMaterial = SCNMaterial()
        
        if diffuseTextureName != "" {
            let dTexture = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: diffuseTextureName, ofType: "png")!)!)
            newMaterial.setValue(dTexture, forKey: "diffuseTexture")
        }
        if reflectiveTextureName != "" {
            let rTexture = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: reflectiveTextureName, ofType: "png")!)!)
            newMaterial.setValue(rTexture, forKey: "reflectiveTexture")
        }
        newMaterial.setValue(shadingScheme.rawValue, forKey: "shadingScheme")
        newMaterial.setValue(textureDimensions, forKey: "textureDimensions")
        
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
    
    func createMaterialWithShadersAndArguments(geometry: String = "", surface: String = "", lighting: String = "", fragment: String = "", _shadingScheme: mangaShadingScheme, _diffuseTetureName: String = "", _reflectiveTextureName: String = "", _textureDimensions: CGPoint = CGPoint.zero) ->SCNMaterial {
        
        diffuseTextureName = _diffuseTetureName
        reflectiveTextureName = _reflectiveTextureName
        shadingScheme = _shadingScheme
        textureDimensions = _textureDimensions
        
        return self.createMaterialWithShaders(geometry,surface: surface,lighting: lighting,fragment: fragment)
    }
    
    func backToDefaultValues() {
        shadingScheme = mangaShadingScheme.solidSingleShadow
        diffuseTextureName = ""
        reflectiveTextureName = ""
        textureDimensions = CGPoint.zero

    }
}

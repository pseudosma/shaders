//
//  waterColorShaderPrimer.swift
//  anotherShaderTest
//
//  Created by DM on 9/11/16.
//  Copyright © 2016 DM. All rights reserved.
//

import SceneKit

///blah blah
class waterColorShaderPrimer: shaderPrimer {
    
    var lightPosition: SCNVector3
    var objectPosition: SCNVector3
    var objectColor: SCNVector3
    var coolColor: SCNVector3
    var warmColor: SCNVector3
    var alpha_Beta_litDistance: SCNVector3
    var outline_popColors_distanceOutline_extraTexture: SCNVector4
    var extraTextureName: String
    
    override init() {
        
        lightPosition = SCNVector3(0.0,0.0,0.0)
        objectPosition = SCNVector3(0.0,0.0,0.0)
        objectColor = SCNVector3(0.5, 0.5, 0.5)
        coolColor = SCNVector3(0.0, 0.0, 0.0)
        warmColor = SCNVector3(1.0,1.0,1.0)
        alpha_Beta_litDistance = SCNVector3(0.75,0.25,20.0)
        outline_popColors_distanceOutline_extraTexture = SCNVector4(0.0,0.0,0.0,0.0)
        extraTextureName = ""
        super.init()
    }
    
    /// Override specific for water color shader set.
    /// - Returns: SCNMaterial
    override func createMaterialWithShaders(_ geometry: String = "", surface: String = "", lighting: String = "", fragment: String = "") ->SCNMaterial {
        //works on .shader files only in the shader folder. Back face culling enabled
        let newMaterial = SCNMaterial()
        var pathString = "art.scnassets/paperTexture1"
        let newMaterial1 = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture2"
        let newMaterial2 = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture3"
        let newMaterial3 = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture4"
        let newMaterial4 = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture5"
        let newMaterial5 = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/brushStrokes"
        let newMaterial6 = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        //basic background textures
        newMaterial.setValue(newMaterial1, forKey: "paperTexture1")
        newMaterial.setValue(newMaterial2, forKey: "paperTexture2")
        newMaterial.setValue(newMaterial3, forKey: "paperTexture3")
        newMaterial.setValue(newMaterial4, forKey: "paperTexture4")
        newMaterial.setValue(newMaterial5, forKey: "paperTexture5")
        newMaterial.setValue(newMaterial6, forKey: "brushStrokes")
        //uniforms from other properties
        newMaterial.setValue(NSValue(scnVector3: lightPosition), forKey: "lightPosition")
        newMaterial.setValue(NSValue(scnVector3: objectColor), forKey: "objectPostition")
        newMaterial.setValue(NSValue(scnVector3: objectColor), forKey: "objectColor")
        newMaterial.setValue(NSValue(scnVector3: coolColor), forKey: "coolColor")
        newMaterial.setValue(NSValue(scnVector3: warmColor), forKey: "warmColor")
        newMaterial.setValue(NSValue(scnVector3: alpha_Beta_litDistance), forKey: "alpha_Beta_litDistance")
        newMaterial.setValue(NSValue(scnVector4: outline_popColors_distanceOutline_extraTexture), forKey: "outline_popColors_distanceOutline_extraTexture")
        if extraTextureName != "" && outline_popColors_distanceOutline_extraTexture.w == 1.0{
            let extraTexture = SCNMaterialProperty.init(contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: extraTextureName, ofType: "png")!)!)
            newMaterial.setValue(extraTexture, forKey: "extraTexture")
        }
        
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
    
    /// Returns an SCNMaterial based on the water color shader set but allows all meaningful parameters to be passed into a single method. This method clears the existing shader parameters before applying new ones.
    /// - Returns: SCNMaterial
    func createMaterialWithShadersAndArguments(_ geometry: String = "", surface: String = "", lighting: String = "", fragment: String = "", _lightPosition: SCNVector3, _objectPosition: SCNVector3, _objectColor: SCNVector3, _coolColor: SCNVector3, _warmColor: SCNVector3, _alpha_Beta_litDistance: SCNVector3, _outline_popColors_distanceOutline_extraTexture: SCNVector4, _extraTextureName: String = "") ->SCNMaterial {
        
        
        
        self.backToDefaultValues()
        
        lightPosition = _lightPosition
        objectPosition = _objectPosition
        objectColor = _objectColor
        coolColor = _coolColor
        warmColor = _warmColor
        alpha_Beta_litDistance = _alpha_Beta_litDistance
        outline_popColors_distanceOutline_extraTexture = _outline_popColors_distanceOutline_extraTexture
        extraTextureName = _extraTextureName
        
        let newMaterial = self.createMaterialWithShaders(geometry,surface: surface,lighting: lighting,fragment: fragment)
        
        return newMaterial
    }
    
    /// Returns an SCNMaterial with preset values specific to the water color shader set.
    /// - Returns: SCNMaterial
    func createMaterialWithWaterColorShaders() ->SCNMaterial {
        let newMaterial = self.createMaterialWithShaders("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment")
        return newMaterial
    }
    
    func backToDefaultValues() {
        lightPosition = SCNVector3(0.0,0.0,0.0)
        objectPosition = SCNVector3(0.0,0.0,0.0)
        objectColor = SCNVector3(0.5, 0.5, 0.5)
        coolColor = SCNVector3(0.0, 0.0, 0.0)
        warmColor = SCNVector3(1.0,1.0,1.0)
        alpha_Beta_litDistance = SCNVector3(0.75,0.25,20.0)
        outline_popColors_distanceOutline_extraTexture = SCNVector4(0.0,0.0,0.0,0.0)
        extraTextureName = ""
    }
}

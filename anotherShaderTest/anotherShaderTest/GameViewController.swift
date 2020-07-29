//
//  GameViewController.swift
//  anotherShaderTest
//
//  Created by DM on 9/5/16.
//  Copyright (c) 2016 DM. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        // create a new scene
        let scene = SCNScene()
        var technique = SCNTechnique()
        
        if let path = Bundle.main.path(forResource: "art.scnassets/shaders/post_technique", ofType: "plist") {
            if let dico1 = NSDictionary(contentsOfFile: path)  {
                let dico = dico1 as! [String : AnyObject]
                technique = SCNTechnique(dictionary:dico)!
                let size =  self.view.frame.size.applying(CGAffineTransform(scaleX: 2.0, y: 2.0))
                technique.setValue(NSValue.init(size: size), forKeyPath: "size_screen")
                self.gameView!.technique = technique
                print("found technique")
            }
        }
        
        
        let waterColorPrimer = waterColorShaderPrimer.init()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.zFar = 1000.0
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 20)
        
        // create and add a light to the scene
        let lightNode1 = SCNNode()
        lightNode1.light = SCNLight()
        lightNode1.light!.type = SCNLight.LightType.omni
        lightNode1.position = SCNVector3(x: -10, y: 15, z: -5)
        lightNode1.light!.attenuationStartDistance = 18.9
        lightNode1.light!.attenuationEndDistance = 19.0
        lightNode1.light!.zFar = 19.0
        lightNode1.light!.zNear = 0.5
        scene.rootNode.addChildNode(lightNode1)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLight.LightType.omni
        lightNode2.position = SCNVector3(x: 0, y: 15, z: 145)
        lightNode2.light!.attenuationStartDistance = 4.9
        lightNode2.light!.attenuationEndDistance = 5.0
        lightNode2.light!.zFar = 19.0
        lightNode2.light!.zNear = 0.3
        scene.rootNode.addChildNode(lightNode2)
        
        let lightNode3 = SCNNode()
        lightNode3.light = SCNLight()
        lightNode3.light!.type = SCNLight.LightType.omni
        lightNode3.position = SCNVector3(x: -5, y: 150, z: -135)
        lightNode3.light!.attenuationStartDistance = 89.0
        lightNode3.light!.attenuationEndDistance = 90.0
        lightNode3.light!.zFar = 90.0
        lightNode3.light!.zNear = 0.3
        scene.rootNode.addChildNode(lightNode3)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let bgImage = NSImage.init(contentsOfFile: Bundle.main.path(forResource: "art.scnassets/paperTexture5", ofType: "jpg")!)

        /*let dotMaterial = SCNMaterial()
        let shaderProgram = SCNProgram()
        shaderProgram.fragmentFunctionName  = "myFragment"
        shaderProgram.vertexFunctionName = "myVertex"
        
        dotMaterial.program = shaderProgram
        let imageProperty = SCNMaterialProperty(contents: bgImage)
        // The name you supply here should match the texture parameter name in the fragment shader
        dotMaterial.setValue(imageProperty, forKey: "diffuseTexture")*/
        
        let landNode = (SCNScene(named: "art.scnassets/natureScene.dae")!).rootNode.childNode(withName: "Land", recursively: true)!
        let shadedMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment",_lightPosition: lightNode1.position, _objectPosition: landNode.position, _objectColor: SCNVector3(0.0, 0.0, 0.0), _coolColor: SCNVector3(0/255.0, 147.0/255.0, 0/255.0), _warmColor: SCNVector3(1.0,1.0,1.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,20.0), _outline_popColors_distanceOutline_extraTexture: SCNVector4(0.0,0.0,0.0,0.0))
        landNode.geometry?.materials = [shadedMaterial]
        scene.rootNode.addChildNode(landNode)
        
        let mountainNode = (SCNScene(named: "art.scnassets/natureScene.dae")!).rootNode.childNode(withName: "mountain", recursively: true)!
        waterColorPrimer.alpha_Beta_litDistance.z = 90.0
        waterColorPrimer.outline_popColors_distanceOutline_extraTexture.z = 1.0
        waterColorPrimer.lightPosition = lightNode3.position
        waterColorPrimer.objectPosition = mountainNode.position
        let mountainShaderMaterial = waterColorPrimer.createMaterialWithWaterColorShaders()
        mountainNode.geometry?.materials = [mountainShaderMaterial]
        scene.rootNode.addChildNode(mountainNode)
        
        let ruinsNode = (SCNScene(named: "art.scnassets/natureScene.dae")!).rootNode.childNode(withName: "ruins", recursively: true)!
        waterColorPrimer.outline_popColors_distanceOutline_extraTexture.z = 0.0
        waterColorPrimer.alpha_Beta_litDistance.z = 20.0
        waterColorPrimer.coolColor = SCNVector3(81.0/255.0, 83.0/255.0, 83.0/255.0)
        waterColorPrimer.lightPosition = lightNode2.position
        waterColorPrimer.objectPosition = ruinsNode.position
        let ruinsShaderMaterial = waterColorPrimer.createMaterialWithWaterColorShaders()
        ruinsNode.geometry?.materials = [ruinsShaderMaterial]
        scene.rootNode.addChildNode(ruinsNode)
        
        let curtainNode = (SCNScene(named: "art.scnassets/natureScene.dae")!).rootNode.childNode(withName: "curtain", recursively: true)!
        let curtainShaderMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment", _lightPosition: lightNode2.position, _objectPosition: curtainNode.position, _objectColor: SCNVector3(1.0, 83.0/255.0, 137.0/255.0), _coolColor: SCNVector3(1.0, 83.0/255.0, 137.0/255.0), _warmColor: SCNVector3(1.0, 83.0/255.0, 137.0/255.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,20.0), _outline_popColors_distanceOutline_extraTexture: SCNVector4(0.0,1.0,0.0,1.0), _extraTextureName: "art.scnassets/extraTexture")
        curtainNode.geometry?.materials = [curtainShaderMaterial]
        scene.rootNode.addChildNode(curtainNode)
        
        
        let treeNode = (SCNScene(named: "art.scnassets/natureScene.dae")!).rootNode.childNode(withName: "Tree", recursively: true)!
        let treeShaderMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment", _lightPosition: lightNode1.position, _objectPosition: treeNode.position, _objectColor: SCNVector3(0.0, 0.0, 0.0), _coolColor: SCNVector3(92.0/255.0, 58.0/255.0, 30.0/255.0), _warmColor: SCNVector3(1.0, 1.0, 1.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,20.0), _outline_popColors_distanceOutline_extraTexture: SCNVector4(1.0,0.0,0.0,0.0))
        treeNode.geometry?.materials = [treeShaderMaterial]
        scene.rootNode.addChildNode(treeNode)

        
        // animate the 3d object

        // set the scene to the view
        scene.background.contents = bgImage
        self.gameView!.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        
        // configure the view
    }

}


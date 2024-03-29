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
        
        let waterColorPrimer = waterColorShaderPrimer.init()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.zFar = 1000.0
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.rotation = SCNVector4Make(0, 0.9, 0, 0.9)
        cameraNode.position = SCNVector3(x: 380, y: 10, z: 10)
        
        // create and add a light to the scene
        let lightNode1 = SCNNode()
        lightNode1.light = SCNLight()
        lightNode1.light!.type = SCNLight.LightType.omni
        lightNode1.position = SCNVector3(x: 300, y: 100, z: -100)
        //lightNode1.rotation = SCNVector4Make(0, -0.9, -0.9, 1)
        lightNode1.light!.attenuationStartDistance = 98.9
        lightNode1.light!.attenuationEndDistance = 99.0
        lightNode1.light!.zFar = 100
        lightNode1.light!.zNear = 0.5
        scene.rootNode.addChildNode(lightNode1)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLight.LightType.omni
        lightNode2.position = SCNVector3(x: 300, y: 60, z: -80)
        //lightNode2.rotation = SCNVector4Make(-0.5, 1, 0, 2.5)
        lightNode2.light!.attenuationStartDistance = 68.9
        lightNode2.light!.attenuationEndDistance = 69.0
        lightNode2.light!.zFar = 70
        lightNode2.light!.zNear = 0.5
        scene.rootNode.addChildNode(lightNode2)
        
        let lightNode3 = SCNNode()
        lightNode3.light = SCNLight()
        lightNode3.light!.type = SCNLight.LightType.spot
        lightNode3.position = SCNVector3(x: -15, y: 50, z: 10)
        lightNode3.rotation = SCNVector4Make(0, -0.5, -0.7, 3)
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
        
        let landNode = (SCNScene(named: "art.scnassets/windmills.dae")!).rootNode.childNode(withName: "land", recursively: true)!
        let shadedMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment",_lightPosition: lightNode1.position, _objectPosition: landNode.position, _objectColor: SCNVector3(0.0, 0.0, 0.0), _coolColor: SCNVector3(100/255.0, 50/255.0, 50/255.0), _warmColor: SCNVector3(1.0,1.0,1.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,150), _outline_popColors_distanceOutline_extraTexture: SCNVector4(0.0,0.0,0.0,0.0))
        landNode.geometry?.materials = [shadedMaterial]
        scene.rootNode.addChildNode(landNode)
        
        let windmillGroundNode = (SCNScene(named: "art.scnassets/windmills.dae")!).rootNode.childNode(withName: "millGround1", recursively: true)!
        windmillGroundNode.geometry?.materials = [shadedMaterial]
        scene.rootNode.addChildNode(windmillGroundNode)
        
        let windmillNode = (SCNScene(named: "art.scnassets/windmills.dae")!).rootNode.childNode(withName: "mill1", recursively: true)!
        windmillNode.geometry?.materials = [shadedMaterial]
        scene.rootNode.addChildNode(windmillNode)
        
        let spokesNode = (SCNScene(named: "art.scnassets/windmills.dae")!).rootNode.childNode(withName: "spokes1", recursively: true)!
        let otherShadedMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment",_lightPosition: lightNode1.position, _objectPosition: landNode.position, _objectColor: SCNVector3(0.0, 0.0, 0.0), _coolColor: SCNVector3(100/255.0, 50/255.0, 50/255.0), _warmColor: SCNVector3(1.0,1.0,1.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,150), _outline_popColors_distanceOutline_extraTexture: SCNVector4(0.0,0.0,0.0,0.0))
        spokesNode.geometry?.materials = [otherShadedMaterial]
        scene.rootNode.addChildNode(spokesNode)
        
        
        /*let grassTex = (contents: NSImage.init(contentsOfFile: Bundle.main.path(forResource: "art.scnassets/grassTex", ofType: "png")!)!)
        
        var n = 0.0
        
        while n < 1 {
            n += 0.1
            let p = SCNPlane.init(width: 10, height: 10)
            p.firstMaterial?.diffuse.contents = grassTex
            let pN = SCNNode.init(geometry: p)
            pN.transform = SCNMatrix4Rotate(pN.transform, -1.57, 1, 0, 0)
            pN.position = SCNVector3(x: 0, y: CGFloat(n), z: 0)
            scene.rootNode.addChildNode(pN)
        }*/
        
        
        /*let grassesNode = (SCNScene(named: "art.scnassets/house scene.dae")!).rootNode.childNode(withName: "grasses", recursively: true)!
        let shadedMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment",_lightPosition: lightNode1.position, _objectPosition: grassesNode.position, _objectColor: SCNVector3(0.0, 0.0, 0.0), _coolColor: SCNVector3(100/255.0, 50/255.0, 50/255.0), _warmColor: SCNVector3(1.0,1.0,1.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,40), _outline_popColors_distanceOutline_extraTexture: SCNVector4(0.0,0.0,0.0,0.0))
        grassesNode.geometry?.materials = [shadedMaterial]
        scene.rootNode.addChildNode(grassesNode)
        
        let groundNode = (SCNScene(named: "art.scnassets/house scene.dae")!).rootNode.childNode(withName: "Ground", recursively: true)!
        let otherShadedMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment",_lightPosition: lightNode3.position, _objectPosition: grassesNode.position, _objectColor: SCNVector3(0.0, 0.0, 0.0), _coolColor: SCNVector3(130/255.0, 100/255.0, 100/255.0), _warmColor: SCNVector3(1.0,1.0,1.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,60), _outline_popColors_distanceOutline_extraTexture: SCNVector4(0.0,0.0,0.0,0.0))
        groundNode.geometry?.materials = [otherShadedMaterial]
        scene.rootNode.addChildNode(groundNode)
        
        let houseNode = (SCNScene(named: "art.scnassets/house scene.dae")!).rootNode.childNode(withName: "house", recursively: true)!
                let nextShadedMaterial = waterColorPrimer.createMaterialWithShadersAndArguments("", surface: "waterColorSurface", lighting: "waterColorLighting", fragment: "waterColorFragment",_lightPosition: lightNode1.position, _objectPosition: grassesNode.position, _objectColor: SCNVector3(0.0, 0.0, 0.0), _coolColor: SCNVector3(100/255.0, 50/255.0, 50/255.0), _warmColor: SCNVector3(1.0,1.0,1.0), _alpha_Beta_litDistance: SCNVector3(0.75,0.25,500), _outline_popColors_distanceOutline_extraTexture: SCNVector4(0.0,0.0,0.0,0.0))
        houseNode.geometry?.materials = [nextShadedMaterial]
        scene.rootNode.addChildNode(houseNode)
        
        let fenceNode = (SCNScene(named: "art.scnassets/house scene.dae")!).rootNode.childNode(withName: "fence", recursively: true)!
        fenceNode.geometry?.materials = [nextShadedMaterial]
        scene.rootNode.addChildNode(fenceNode)
        
        
        let treeNode1 = (SCNScene(named: "art.scnassets/house scene.dae")!).rootNode.childNode(withName: "trees1", recursively: true)!
        treeNode1.geometry?.materials = [nextShadedMaterial]
        scene.rootNode.addChildNode(treeNode1)
        
        let treeNode2 = (SCNScene(named: "art.scnassets/house scene.dae")!).rootNode.childNode(withName: "trees_2", recursively: true)!
        treeNode2.geometry?.materials = [otherShadedMaterial]
        scene.rootNode.addChildNode(treeNode2)
        
        let treeNode3 = (SCNScene(named: "art.scnassets/house scene.dae")!).rootNode.childNode(withName: "trees_3", recursively: true)!
        treeNode3.geometry?.materials = [otherShadedMaterial]
        scene.rootNode.addChildNode(treeNode3)*/
        
        

        
        // animate the 3d object

        // set the scene to the view
        scene.background.contents = bgImage
        self.gameView!.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        
        let firstPass: [String: Any] = [
            "outputs": [
                "color": "intermed"
            ],
            "inputs": [
                "colorSampler": "COLOR",
                "depth": "DEPTH",
                "a_position": "a_position-symbol",
                "size": "screen_size"
            ],
            "program": "art.scnassets/shaders/first",
            "draw": "DRAW_QUAD"
        ]
        
        let secondPass: [String: Any] = [
            "outputs": [
                "color": "COLOR"
            ],
            "inputs": [
                "colorSampler": "COLOR",
                "depthSampler": "DEPTH",
                "depthFirstPass": "intermed",
                "a_position": "a_position-symbol",
                "u_time": "u_time-symbol",
                "dropsNormalSampler1": "normal_map1",
                "dropsNormalSampler2": "normal_map2",
                "size": "screen_size",
            ],
            "program": "art.scnassets/shaders/second",
            "draw": "DRAW_QUAD"
        ]
        
        let techniqueDef: [String: Any] = [
            "passes": [
                "first-pass": firstPass,
                "second-pass": secondPass,
            ],
            
            "sequence": [
                "first-pass", "second-pass"
            ],
            
            "symbols": [
                "normal_map1": ["type": "sampler2D", "image": "art.scnassets/shaders/normal_map.jpg"],
                "normal_map2": ["type": "sampler2D", "image": "art.scnassets/shaders/normal_map2.jpg"],
                "u_time-symbol": ["semantic": "time"],
                "screen_size": ["type": "vec2"], //this is added externally
                "a_position-symbol": ["semantic": "vertex"],
            ],
            
            "targets": [
                "intermed": [
                    "type": "color",
                ],
                "COLOR": [
                    "type": "color",
                ]
            ]
        ]
        
        //define the technique from the dictionary
        let t = SCNTechnique(dictionary: techniqueDef)
        //inject the size variable
        let size =  self.view.frame.size.applying(CGAffineTransform(scaleX: 2.0, y: 2.0))
        t!.setValue(NSValue.init(size: size), forKeyPath: "screen_size")
        //finally set the scene's technuique
        self.gameView!.technique = t
    }

}


//
//  GameViewController.swift
//  shadingTest
//
//  Created by DM on 7/2/16.
//  Copyright (c) 2016 DM. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
    
extension String {
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }
    
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }
}

class GameViewController: UIViewController {
    
    //private var time: Float = 0.0
    //private var timer = NSTimer()
    let scene = SCNScene()
    var dist:Float = 0.0
    var defaultText:String = ""
    var index:Int = 0
    var camXPosition:SCNFloat = SCNFloat(0)
    var updateInterval:TimeInterval = 0
    let uppers:[Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let lowers:[Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let specials:[Character:String] = ["\"":"doublequote","\\":"backslash","?":"questionmark","!":"exclamationpoint",",":"comma",".":"period","'":"singlequote","(":"openparen",")":"closeparen",":":"colon",";":"semicolon","/":"forwardslash","-":"dash"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //timer = NSTimer.init(timeInterval: 1.0, target: self, selector: "incrementTime", userInfo: nil, repeats: true)
        
        // create a new scene
        //let scene = SCNScene()
        defaultText = textGenerate()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        //cameraNode.camera!.zFar = 100.0
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(0, 0, 15)
        //cameraNode.rotation = SCNVector4Make(0, 1, 0, -1.57)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 1, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        //let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        //ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        
        // set the scene to the view
        scnView.scene = scene
        scnView.delegate = self
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        //scene.background.contents = newMaterial
        scnView.backgroundColor = UIColor.white
        
        // add a tap gesture recognizer
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
         var gestureRecognizers = [UIGestureRecognizer]()
         gestureRecognizers.append(tapGesture)
         if let existingGestureRecognizers = scnView.gestureRecognizers {
         gestureRecognizers.append(contentsOf: existingGestureRecognizers)
         }
         scnView.gestureRecognizers = gestureRecognizers*/
        
        //create material
        
        /*var pathString = "art.scnassets/hatchTexture"
        let dotPic: UIImage? = UIImage.init(contentsOfFile: NSBundle.mainBundle().pathForResource(pathString, ofType: "png")!)
        
        let dotPattern = UIColor.init(patternImage: dotPic!)
        let dotPicArray = NSArray.init(array: [dotPic!,dotPic!,dotPic!,dotPic!,dotPic!,dotPic!], copyItems: true)
        let dotMaterial = SCNMaterial.init()
        dotMaterial.reflective.contents = dotPicArray
        dotMaterial.reflective.contentsTransform = SCNMatrix4MakeScale(0.25, 0.25, 0.25)
        dotMaterial.reflective.wrapS = SCNWrapMode.Mirror
        dotMaterial.reflective.wrapT = SCNWrapMode.Mirror*/
        
        var pathString = "art.scnassets/paperTexture1"
        let newMaterial = SCNMaterialProperty.init(contents: UIImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture2"
        let newMaterial2 = SCNMaterialProperty.init(contents: UIImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture3"
        let newMaterial3 = SCNMaterialProperty.init(contents: UIImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture4"
        let newMaterial4 = SCNMaterialProperty.init(contents: UIImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/paperTexture5"
        let newMaterial5 = SCNMaterialProperty.init(contents: UIImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)
        
        pathString = "art.scnassets/brushStrokes"
        let newMaterial6 = SCNMaterialProperty.init(contents: UIImage.init(contentsOfFile: Bundle.main.path(forResource: pathString, ofType: "jpg")!)!)

        let dotMaterial = createMaterialWithShaders(geometry: "", surface: "surface", lighting: "lighting", fragment: "fragment")
        
        dotMaterial.setValue(newMaterial, forKey: "paperTexture1")
        dotMaterial.setValue(newMaterial2, forKey: "paperTexture2")
        dotMaterial.setValue(newMaterial3, forKey: "paperTexture3")
        dotMaterial.setValue(newMaterial4, forKey: "paperTexture4")
        dotMaterial.setValue(newMaterial5, forKey: "paperTexture5")
        dotMaterial.setValue(newMaterial6, forKey: "brushStrokes")


        
        //dotMaterial.litPerPixel = false
        
        

        /*let dotMaterial = SCNMaterial()
        let shaderProgram = SCNProgram()
        shaderProgram.fragmentFunctionName  = "cel_shading_fragment"
        shaderProgram.vertexFunctionName = "cel_shading_vertex"
        
        /*if let vertexShaderPath = NSBundle.mainBundle().pathForResource("art.scnassets/shaders/vertex", ofType: "vert") {
            do {
                let contents = try NSString(contentsOfFile: vertexShaderPath, encoding: NSUTF8StringEncoding) as String
                shaderProgram.vertexShader = contents
            } catch {
                print("failed to load vertex shader")
            }
        }
        
        if let fragmentShaderPath = NSBundle.mainBundle().pathForResource("art.scnassets/shaders/fragment", ofType:"frag")
        {
            do {
                let fragmentShaderAsString = try NSString(contentsOfFile: fragmentShaderPath, encoding: NSUTF8StringEncoding)
                shaderProgram.fragmentShader = fragmentShaderAsString as String
            } catch {
                print("failed to load fragment shader")  
            }  
        }*/
        
        dotMaterial.program = shaderProgram*/
        
        
        /*let sphere = SCNSphere.init(radius: 2)
        let spherNode = SCNNode.init(geometry: sphere)
        spherNode.position = SCNVector3(x: 5, y: 0, z: 0)
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        sphere.materials = [dotMaterial]
        scene.rootNode.addChildNode(spherNode)

        let cap = SCNCapsule.init(capRadius: 0.5, height: 3)
        let capNode = SCNNode.init(geometry: cap)
        capNode.position = SCNVector3(x: 0, y: 0, z: 0)
        //capNode.geometry?.firstMaterial?.program = shaderProgram
        //capNode.geometry?.firstMaterial?.setValue(time, forKey: "Time")
        cap.materials = [dotMaterial]
        scene.rootNode.addChildNode(capNode)
        
        let cone = SCNCone.init(topRadius: 0.5, bottomRadius: 2, height: 2)
        let coneNode = SCNNode.init(geometry: cone)
        coneNode.position = SCNVector3(x: -5, y: 0, z: 0)
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        cone.materials = [dotMaterial]
        scene.rootNode.addChildNode(coneNode)
        
        let box = SCNBox.init(width: 2, height: 2, length: 2, chamferRadius: 0)
        let boxNode = SCNNode.init(geometry: box)
        boxNode.position = SCNVector3(x: 0, y: 5, z: 0)
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        box.materials = [dotMaterial,dotMaterial,dotMaterial,dotMaterial,dotMaterial,dotMaterial]
        scene.rootNode.addChildNode(boxNode)
        
        let plane = SCNPlane.init(width: 2, height: 2)
        let planeNode = SCNNode.init(geometry: plane)
        planeNode.position = SCNVector3(x: 0, y: -5, z: 0)
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        plane.materials = [dotMaterial]
        scene.rootNode.addChildNode(planeNode)*/
        
        /*let letter = SCNText.init(string: "i", extrusionDepth: 1.0)
        letter.chamferRadius = 3.0
        letter.font = UIFont.init(name: "Courier", size: 10.0)
        let textNode = SCNNode.init(geometry: letter)
        textNode.position = SCNVector3(x: -10, y: -10, z: 0)
        dotMaterial.setValue(NSValue(SCNVector3: lightNode.position), forKey: "LightingPosition")
        letter.materials = [dotMaterial]
        scene.rootNode.addChildNode(textNode)*/
        
        /*let  textNode = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: "Z", recursively: true)!
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        textNode.geometry?.materials = [dotMaterial]
        textNode.position = SCNVector3(x: -5, y: 0, z: 0)
        scene.rootNode.addChildNode(textNode)
        
        let  textNode2 = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: "e", recursively: true)!
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        textNode2.geometry?.materials = [dotMaterial]
        textNode2.position = SCNVector3(x: -4.4, y: 0, z: 0)
        scene.rootNode.addChildNode(textNode2)
        
        let  textNode3 = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: "d", recursively: true)!
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        textNode3.geometry?.materials = [dotMaterial]
        textNode3.position = SCNVector3(x: -3.9, y: 0, z: 0)
        scene.rootNode.addChildNode(textNode3)
        
        let  textNode4 = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: "X", recursively: true)!
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        textNode4.geometry?.materials = [dotMaterial]
        textNode4.position = SCNVector3(x: -2.9, y: 0, z: 0)
        scene.rootNode.addChildNode(textNode4)
        
        let  textNode5 = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: "E", recursively: true)!
        dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
        textNode5.geometry?.materials = [dotMaterial]
        textNode5.position = SCNVector3(x: -2.2, y: 0, z: 0)
        scene.rootNode.addChildNode(textNode5)
            */
 
        let  protagonistNode = (SCNScene(named: "art.scnassets/characterIdle.dae")!).rootNode.childNode(withName: "holder", recursively: true)!
        protagonistNode.rotation = SCNVector4(0, 1, 0, 1.57)
        protagonistNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        
        let prefix = defaultText[0...30]
        index = 30
        
        
        for char in prefix.characters {
            print(char)
            textNodeLoad(path: "art.scnassets/characterIdle.dae", scn: scene, charIdentifier: char, xPosition: &dist)
        }
        
        //protagonistNode.childNode(withName: "protagonist", recursively: true)?.removeAllActions()
        //protagonistNode.removeAllActions()

        scene.rootNode.addChildNode(protagonistNode)
        
        //protagonistNode.childNode(withName: "Armature", recursively: true)?.removeAllAnimations()
        //protagonistNode.childNode(withName: "protagonist", recursively: true)?.removeAllAnimations()
        //protagonistNode.removeAllAnimations()
        
        //print(protagonistNode.childNode(withName: "protagonist", recursively: true)?.animationKeys as Any)
        //print(protagonistNode.childNode(withName: "protagonist", recursively: true)?.animationKeys as Any)
        //print(protagonistNode.animationKeys as Any)
        //print(scene.rootNode.animationKeys as Any)
        

        
        let url = Bundle.main.url(forResource: "art.scnassets/characterWalk", withExtension: "dae")
        let source = SCNSceneSource.init(url: url!, options: nil)
        
        print(source?.identifiersOfEntries(withClass: CAAnimation.self) as Any)
        let animation: CAAnimation = (source?.entryWithIdentifier("characterWalk-1", withClass: CAAnimation.self))!
        scene.rootNode.addAnimation(animation, forKey: "characterWalk-1")
        print(scene.rootNode.animationKeys as Any)
           
        //protagonistNode.childNode(withName: "Armature", recursively: true)?.addAnimation((protagonistNode.childNode(withName: "Armature", recursively: true)?.animation(forKey: "character-3"))!, forKey: "character-3")
        
        //let animationObject:CAAnimation = (source?.entryWithIdentifier("keyframedAnimations247", withClass: CAAnimation.self))!
        //protagonistNode.childNode(withName: "Armature", recursively: true)?.addAnimation(animationObject, forKey: "keyframedAnimations247")
        


        //spherNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: -1, y: 0.5, z: 0.7, duration: 1)))
        //capNode.runAction(SCNAction.repeatForever(SCNAction.moveBy(x: 1, y: 2, z: 0.9, duration: 3)))
        //coneNode.runAction(SCNAction.repeatForever(SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 5.0)))

        //boxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.2, z: 0, duration: 1)))
        //planeNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0.3, y: 1, z: 0.3, duration: 1)))
        //textNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.2, z: 0, duration: 1)))
        
        scnView.isPlaying = true
        
    }
    
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            /*SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }*/
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    private func createMaterialWithShaders(geometry: String = "", surface: String = "", lighting: String = "", fragment: String = "") ->SCNMaterial {
        //works on .shader files only in the shader folder. Back face culling enabled
        let newMaterial = SCNMaterial()
        var shaders = [SCNShaderModifierEntryPoint: String]()
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
    
    func textNodeCycle(text: String, path: String, scn: SCNScene, cameraXPosition: SCNFloat, distance: inout Float, i: inout Int){
        //encapsulates creating and removing text from the string based on camera postition
        
        while distance - cameraXPosition > 3 {
            textNodeLoad(path: path, scn: scn, charIdentifier: text[i], xPosition: &distance)
            i += 1
        }
        //texNodeUnload for items off screen
        
        //needs to support forward and backwards reading
        
        //incrementInterval
        updateInterval.add(1)
    }
    
    func textNodeLoad(path: String, scn: SCNScene, charIdentifier: Character, xPosition: inout Float) {
        //0.6 apart for lowercase, 0.7 apart for uppercase and special chars, 1.0 for spaces
        print(charIdentifier)
        if charIdentifier == " " {
            xPosition += 1.0
        }else if let val = specials[charIdentifier] {
            xPosition += 0.6
            
            let  textNode = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: val, recursively: true)!
            /*dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
            textNode.geometry?.materials = [dotMaterial]*/
            textNode.position = SCNVector3(x: xPosition, y: -2.7, z: 0)
            scn.rootNode.addChildNode(textNode)
            
        }else if uppers.contains(charIdentifier) {
            xPosition += 0.7
            
            let  textNode = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: String.init(charIdentifier), recursively: true)!
            /*dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
            textNode.geometry?.materials = [dotMaterial]*/
            textNode.position = SCNVector3(x: xPosition, y: -2.7, z: 0)
            scn.rootNode.addChildNode(textNode)
            
        }else if lowers.contains(charIdentifier) {
            xPosition += 0.7

            let  textNode = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: String.init(charIdentifier), recursively: true)!
            /*dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
            textNode.geometry?.materials = [dotMaterial]*/
            textNode.position = SCNVector3(x: xPosition, y: -2.7, z: 0)
            scn.rootNode.addChildNode(textNode)
            
        }else {
            xPosition += 0.7

            let  textNode = (SCNScene(named: "art.scnassets/text.dae")!).rootNode.childNode(withName: "special", recursively: true)!
            /*dotMaterial.setValue(NSValue(scnVector3: lightNode.position), forKey: "LightingPosition")
            textNode.geometry?.materials = [dotMaterial]*/
            textNode.position = SCNVector3(x: xPosition, y: -2.7, z: 0)
            scn.rootNode.addChildNode(textNode)
        }
    }
    
    func textNodeUnload( ) {
        
    }
    
    func textGenerate() ->String {
        //eventually this should hit the web for text,then fallback to lorem ipsum
        return "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,"
    }

}

extension GameViewController: SCNSceneRendererDelegate {
    
    private func renderer(renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > updateInterval {
            textNodeCycle(text: defaultText, path: "art.scnassets/text.dae", scn: scene, cameraXPosition: camXPosition, distance: &dist, i: &index)
        }
    }
}

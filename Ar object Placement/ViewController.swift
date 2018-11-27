//
//  ViewController.swift
//  Ar object Placement
//
//  Created by Alessandro Parisi on 20/11/2018.
//  Copyright © 2018 Alessandro Parisi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
class ViewController: UIViewController, ARSCNViewDelegate {
    var player: AVAudioPlayer!
    @IBOutlet var sceneView: ARSCNView!
    var first = true
    var node: SCNNode?
    
    var map: ARWorldMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Sans/Sans.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        node = scene.rootNode.childNode(withName: "Sansa", recursively: true)
        node!.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 10, z: 0, duration: 13)))
        //node!.position = SCNVector3(0, -5, -15)
        node!.scale = SCNVector3(0.03, 0.03, 0.03)
        //node!.position = SCNVector3(0, -0.1, 0)
        //node!.simdTransform = map?.anchors.first?.transform ?? simd_float4x4(float4(0), float4(0),float4(0),float4(0))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal
        configuration.initialWorldMap = map
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.0000000000001)
        
        let planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi/2
        
        node.addChildNode(planeNode)
        if first{
            node.addChildNode(self.node!)
            self.node!.position = SCNVector3(x, y, z)
            do{
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Spooky - Scary", ofType: "mp3")!))
                player.numberOfLoops = Int.max
                player.play()
            } catch{
                
            }
            first = false
        }
    }
}

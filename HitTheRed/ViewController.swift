//
//  ViewController.swift
//  HitTheRed
//
//  Created by Wooyoung Song on 11/27/19.
//  Copyright © 2019 Wooyoung Song. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var gameStartButton: UIButton!
    @IBOutlet weak var scoreText: UITextField!
    
    // game variables
//    var hasTarget = false
    var gameStarted = false
    var score = 0
    var planes : [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/world.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        setupGame()
        gameStartButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if(touch.view == self.sceneView){
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            
            if result.node.isTarget() {
                result.node.touchedAnim()
                result.node.geometry!.firstMaterial?.diffuse.contents = UIColor.darkGray
                score += 1
                scoreText.text = String(score)
                initRed()
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    func setupGame(){
        let node = SCNNode()
        
        let numOfPlane = 25 // change
        let numOfRow = 5 // change
        let distanceBtw = Float(0.5)
        let posZ = Float(-1.25)
        let posX = Float(-1.0) // change
        var posY = Float(-1.0) // change

        var rowIndex = 0

        for i in 1...numOfPlane {
            let plane = SCNBox(width: 0.3, height:0.3, length: 0.1, chamferRadius: 0.5)
            plane.firstMaterial?.diffuse.contents = UIColor.darkGray

            let planeNode = SCNNode(geometry: plane)
            let planePosX = posX + (Float(rowIndex)*distanceBtw)
            let planePosY = posY
            let planePosZ = posZ

            planeNode.position = SCNVector3Make(planePosX, planePosY, planePosZ)
            node.addChildNode(planeNode)
            planes.append(planeNode)
            
            if(i%numOfRow == 0) {
                rowIndex = 0
//                planePosX = posX + (Float(rowIndex)*distanceBtw)
                posY += distanceBtw
            }else {
                rowIndex += 1;
            }
        }
        
//        let plane1 = SCNBox(width: 0.3, height:0.3, length: 0.05, chamferRadius: 0.5)
//        plane1.firstMaterial?.diffuse.contents = UIColor.darkGray
//        let planeNode1 = SCNNode(geometry: plane1)
//        planeNode1.position = SCNVector3Make(-0.5,0,-1.25)
//        node.addChildNode(planeNode1)
//        planes.append(planeNode1)
//
//        let plane2 = SCNBox(width: 0.3, height:0.3, length: 0.05, chamferRadius: 0.15)
//        plane2.firstMaterial?.diffuse.contents = UIColor.darkGray
//        let planeNode2 = SCNNode(geometry: plane2)
//        planeNode2.position = SCNVector3Make(0,0,-1.25)
//        node.addChildNode(planeNode2)
//        planes.append(planeNode2)
//
//        let plane3 = SCNBox(width: 0.3, height:0.3, length: 0.05, chamferRadius: 0.5)
//        plane3.firstMaterial?.diffuse.contents = UIColor.darkGray
//        let planeNode3 = SCNNode(geometry: plane3)
//        planeNode3.position = SCNVector3Make(0.5,0,-1.25)
//        node.addChildNode(planeNode3)
//        planes.append(planeNode3)

        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func initRed(){
        let rand = Int.random(in: 0 ..< planes.count)
        self.planes[rand].geometry!.firstMaterial?.diffuse.contents = UIColor.red
//        if !hasTarget {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.planes[rand].geometry!.firstMaterial?.diffuse.contents = UIColor.red
//                self.hasTarget = true
//            }
//        }else {
//            self.planes[rand].geometry!.firstMaterial?.diffuse.contents = UIColor.red
//        }
    }
    
    @objc func startGame(){
        gameStarted = !gameStarted
        
        if gameStarted{
            // not started, when you click start
            gameStartButton.setTitle("Reset", for: .normal)
            initRed()
        }else {
            // started, when you clikc reset
            gameStartButton.setTitle("Start", for: .normal)
            resetGame()
        }
    }
    
    func resetGame(){
        score = 0
        scoreText.text = String(score)
        
        for plane in planes {
            if plane.isTarget() {
                plane.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
            }
        }
    }
    
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
}

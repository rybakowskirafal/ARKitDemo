//
//  ViewController.swift
//  ARtest
//
//  Created by Rafał Rybakowski on 03/07/2017.
//  Copyright © 2017 Rafał Rybakowski. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SceneViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var objectNode: SCNNode!
    
    var planes: [UUID : Plane] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Lowpoly_tree_sample.dae")!
        self.objectNode = scene.rootNode.childNode(withName: "Tree_lp_11", recursively: true)
        self.objectNode.position = SCNVector3Make(0, 0, -1)
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        
        if !self.planes.isEmpty {
            self.addSavedPlanes()
        }
    }
    func addSavedPlanes () {
        for (_, plane) in self.planes {
            self.sceneView.session.add(anchor: plane.anchor)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.existingPlaneUsingExtent] )
            if let anchor = results.first {
                let hitPointTransform = SCNMatrix4(anchor.worldTransform)
                let hitPointPosition = SCNVector3Make(hitPointTransform.m41, hitPointTransform.m42, hitPointTransform.m43)
                let objClone = self.objectNode.clone()
                objClone.position = hitPointPosition
                sceneView.scene.rootNode.addChildNode(objClone)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonPressed() {
        let scene = Scene(planes: self.planes)
        if !scene.planes().isEmpty {
            SceneManager.shared.saveScene(scene: scene)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let plane = Plane(anchor: anchor as! ARPlaneAnchor)
            node.addChildNode(plane)
            self.planes[anchor.identifier] = plane
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let plane = self.planes[anchor.identifier] {
            if anchor is ARPlaneAnchor {
                plane.update(anchor: anchor as! ARPlaneAnchor)
            }
        }
    }
}


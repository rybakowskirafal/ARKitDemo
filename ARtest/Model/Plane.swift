//
//  Plane.swift
//  ARtest
//
//  Created by Rafał Rybakowski on 21/08/2017.
//  Copyright © 2017 Rafał Rybakowski. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Plane: SCNNode {
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 2.0, 0.0, 0.0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue.withAlphaComponent(0.5)
        self.planeGeometry.materials = [material]
        
        self.addChildNode(planeNode)
        self.updateScaling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        self.planeGeometry.width = CGFloat(self.anchor.extent.x)
        self.planeGeometry.height = CGFloat(self.anchor.extent.z)
        self.position = SCNVector3Make(self.anchor.center.x, 0.0, self.anchor.center.z)
        self.updateScaling()
    }
    
    func updateScaling() {
        if let material = self.planeGeometry.materials.first {
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
            material.diffuse.wrapS = .repeat
            material.diffuse.wrapT = .repeat
        }
    }
}

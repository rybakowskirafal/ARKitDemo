//
//  PlaneManager.swift
//  ARtest
//
//  Created by Rafał Rybakowski on 18/07/2017.
//  Copyright © 2017 Rafał Rybakowski. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class SceneManager : NSObject {
    private override init() { }
    static let shared = SceneManager()
    
    private var savedScenes : [Scene] = []
    
    func saveScene(scene: Scene) {
        self.savedScenes.append(scene)
    }
    
    func scenes() -> [Scene] {
        return self.savedScenes
    }
}

class Scene : NSObject {
    let date: Date
    private var savedPlanes : [UUID : Plane] = [:]
    
    init(planes: [UUID : Plane]) {
        self.date = Date()
        self.savedPlanes = planes
    }
    
    func planes() -> [UUID : Plane] {
        return self.savedPlanes
    }
}


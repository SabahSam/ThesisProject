//
//  ViewController.swift
//  Image Recognition
//
//  Created by Sam Sabah
//

import UIKit
import ARKit
import SceneKit
import SpriteKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
        
        resetTrackingConfiguration()
        
    }
    
}



extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name ?? "no name"
        print(imageName)
        
        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        let videoNode = SKVideoNode(fileNamed: "\(imageName)"+(".mp4"))
        
        videoNode.play()
        
        let skScene = SKScene(size: CGSize(width: 886, height: 1920))
        skScene.addChild(videoNode)
        
        videoNode.position = CGPoint(x: skScene.size.width/2, y: skScene.size.height/2)
        videoNode.size = skScene.size
        
        
        let material = SCNMaterial()
        material.diffuse.contents = skScene
        material.isDoubleSided = true
        plane.materials = [material]
        
        
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = .pi/2
        node.addChildNode(planeNode)
        DispatchQueue.main.async {
            self.label.text = "Image detected: \"\(imageName)\""
        }
        
    }
    


    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        label.text = "Move camera around to detect images"
    }
    


    
}

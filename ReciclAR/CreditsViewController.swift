//
//  CreditsViewController.swift
//  ReciclAR
//
//  Created by Carlos Fernando Garza Martinez on 10/31/19.
//  Copyright © 2019 Carlos Fernando Garza Martinez. All rights reserved.
//

import UIKit
import ARKit

class CreditsViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!

    var nextBall = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene.physicsWorld.contactDelegate = self
        setUpScene()
        upNext()
        isModalInPresentation = true
        // Do any additional setup after loading the view.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    func setUpScene(){
        let configuration = ARWorldTrackingConfiguration()
        sceneView.delegate = self
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
        configureLighting()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func createBall() {
        guard let currentFrame = sceneView.session.currentFrame else {return}
        let randomNum = nextBall;

        switch(randomNum){
            case 0:
                guard let lataScene = SCNScene(named: "micara.scn"),
                let lataNode = lataScene.rootNode.childNode(withName: "OrigenCara", recursively: false)
                else {return}
                let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
                lataNode.transform = cameraTransform
                
                let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: lataNode, options: [SCNPhysicsShape.Option.collisionMargin: 0.01]))
                physicsBody.isAffectedByGravity = false
                lataNode.physicsBody = physicsBody
                
                let power = Float(10.0)
                let force = SCNVector3(-cameraTransform.m31 * power, -cameraTransform.m32 * power, -cameraTransform.m33 * power)
                lataNode.physicsBody?.applyForce(force, asImpulse: true)
                sceneView.scene.rootNode.addChildNode(lataNode)
                lataNode.runAction(
                    SCNAction.sequence([
                        SCNAction.wait(duration: 5.0),
                        SCNAction.removeFromParentNode()
                    ])
                )
                break;
            case 1:
                guard let lataScene = SCNScene(named: "micara2.scn"),
                let lataNode = lataScene.rootNode.childNode(withName: "OrigenCara2", recursively: false)
                else {return}
                let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
                lataNode.transform = cameraTransform
                
                let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: lataNode, options: [SCNPhysicsShape.Option.collisionMargin: 0.01]))
                physicsBody.isAffectedByGravity = false
                lataNode.physicsBody = physicsBody
                
                let power = Float(10.0)
                let force = SCNVector3(-cameraTransform.m31 * power, -cameraTransform.m32 * power, -cameraTransform.m33 * power)
                lataNode.physicsBody?.applyForce(force, asImpulse: true)
                sceneView.scene.rootNode.addChildNode(lataNode)
                lataNode.runAction(
                    SCNAction.sequence([
                        SCNAction.wait(duration: 5.0),
                        SCNAction.removeFromParentNode()
                    ])
                )
                break;
            case 2:
                guard let lataScene = SCNScene(named: "micara3.scn"),
                let lataNode = lataScene.rootNode.childNode(withName: "OrigenCara3", recursively: false)
                else {return}
                let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
                lataNode.transform = cameraTransform
                
                let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: lataNode, options: [SCNPhysicsShape.Option.collisionMargin: 0.01]))
                physicsBody.isAffectedByGravity = false
                lataNode.physicsBody = physicsBody
                
                let power = Float(10.0)
                let force = SCNVector3(-cameraTransform.m31 * power, -cameraTransform.m32 * power, -cameraTransform.m33 * power)
                lataNode.physicsBody?.applyForce(force, asImpulse: true)
                sceneView.scene.rootNode.addChildNode(lataNode)
                lataNode.runAction(
                    SCNAction.sequence([
                        SCNAction.wait(duration: 5.0),
                        SCNAction.removeFromParentNode()
                    ])
                )
                break;
            default:
                break;
        }
    }
    
    func upNext(){
        var randomNum = 0;
        randomNum = Int.random(in: 0...2)
        nextBall = randomNum;
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer) {
        createBall()
        upNext()
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        sceneView.session.pause()
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

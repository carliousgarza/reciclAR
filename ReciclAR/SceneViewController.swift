//
//  SceneViewController.swift
//  ReciclAR
//
//  Created by Carlos Fernando Garza Martinez on 10/30/19.
//  Copyright © 2019 Carlos Fernando Garza Martinez. All rights reserved.
//
//

import UIKit
import ARKit

class SceneViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnInstructions: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var lbReciclar: UILabel!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbScoreLabel: UILabel!
    @IBOutlet weak var imgNextBall: UIImageView!
    @IBOutlet weak var btnCredits: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var nextBall = 0;
    var score = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.session.pause()
        lbScore.isHidden = true
        lbScoreLabel.isHidden = true
        upNext()
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("** Collision!" + contact.nodeA.name! + " hit " + contact.nodeB.name!)
        
        if(contact.nodeA.name! == "DetectorA" && contact.nodeB.name! == "OrigenPapel"){
            contact.nodeB.removeAllActions()
            contact.nodeB.removeAllParticleSystems()
            contact.nodeB.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeper()
            }
        }
        else if (contact.nodeA.name! == "OrigenPapel" && contact.nodeB.name! == "DetectorA"){
            contact.nodeA.removeAllActions()
            contact.nodeA.removeAllParticleSystems()
            contact.nodeA.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeper()
            }
        }
        else if(contact.nodeA.name! == "DetectorV" && contact.nodeB.name! == "OrigenManzana"){
            contact.nodeB.removeAllActions()
            contact.nodeB.removeAllParticleSystems()
            contact.nodeB.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeper()
            }
        }
        else if (contact.nodeA.name! == "OrigenManzana" && contact.nodeB.name! == "DetectorV"){
            contact.nodeA.removeAllActions()
            contact.nodeA.removeAllParticleSystems()
            contact.nodeA.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeper()
            }
        }
        else if(contact.nodeA.name! == "DetectorG" && contact.nodeB.name! == "OrigenLata"){
            contact.nodeB.removeAllActions()
            contact.nodeB.removeAllParticleSystems()
            contact.nodeB.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeper()
            }
        }
        else if (contact.nodeA.name! == "OrigenLata" && contact.nodeB.name! == "DetectorG"){
            contact.nodeA.removeAllActions()
            contact.nodeA.removeAllParticleSystems()
            contact.nodeA.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeper()
            }
        }
        else if (contact.nodeA.name! == "DetectorG" || contact.nodeA.name! == "DetectorA" || contact.nodeA.name! == "DetectorV"){
            contact.nodeB.removeAllActions()
            contact.nodeB.removeAllParticleSystems()
            contact.nodeB.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeperWrong()
            }
        }
        else {
            contact.nodeA.removeAllActions()
            contact.nodeA.removeAllParticleSystems()
            contact.nodeA.removeFromParentNode()
            DispatchQueue.main.async {
                self.scoreKeeperWrong()
            }
        }
    }
    
    func scoreKeeper(){
        score = score + 1
        print(score)
        self.lbScore.text = String(score)
    }
    
    func scoreKeeperWrong(){
        score = score - 1
        print(score)
        self.lbScore.text = String(score)
    }
    
    @IBAction func handleStart(_ sender: UIButton) {
        setUpScene()
        btnStart.isHidden = true
        btnCredits.isHidden = true
        btnInstructions.isHidden = true
        lbReciclar.isHidden = true
        lbScore.isHidden = false
        lbScoreLabel.isHidden = false
        imgLogo.isHidden = true
        createTrashCan()
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
    
    func createTrashCan() {
        guard let homeScene = SCNScene(named: "boteazul.scn"),
            let homeNode = homeScene.rootNode.childNode(withName: "OrigenBAzul", recursively: false)
            else {return}
        homeNode.position = SCNVector3(0,-4,-10)
        
        guard let homeScene2 = SCNScene(named: "boteverde.scn"),
            let homeNode2 = homeScene2.rootNode.childNode(withName: "OrigenBVerde", recursively: false)
            else {return}
        homeNode2.position = SCNVector3(-3,-4,-10)
        
        
        guard let homeScene3 = SCNScene(named: "botegris.scn"),
            let homeNode3 = homeScene3.rootNode.childNode(withName: "OrigenBGris", recursively: false)
            else {return}
        homeNode3.position = SCNVector3(3,-4,-10)
        
        
        
        sceneView.scene.rootNode.addChildNode(homeNode)
        sceneView.scene.rootNode.addChildNode(homeNode2)
        sceneView.scene.rootNode.addChildNode(homeNode3)
    }
    
    func upNext(){
        var randomNum = 0;
        randomNum = Int.random(in: 0...2)
        nextBall = randomNum;
        
        switch randomNum {
            case 0:
                imgNextBall.image = UIImage(named: "lata")
                break;
            case 1:
                imgNextBall.image = UIImage(named: "boladepapel")
                break;
            case 2:
                imgNextBall.image = UIImage(named: "manzana")
                break;
            default:
                print("error")
                break;
        }
    }
    
    func createBall(){
        
        guard let currentFrame = sceneView.session.currentFrame else {return}
        
        let randomNum = nextBall;
        
        switch randomNum {
        case 0:
            
            
            let rotate = SCNAction.rotateBy(x: 2, y: 2, z: 10, duration: 0.1)
            
            guard let lataScene = SCNScene(named: "lata.scn"),
            let lataNode = lataScene.rootNode.childNode(withName: "OrigenLata", recursively: false)
            else {return}
            let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
            lataNode.transform = cameraTransform
            
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: lataNode, options: [SCNPhysicsShape.Option.collisionMargin: 0.01]))
            
            lataNode.physicsBody = physicsBody
            
            let power = Float(10.0)
            let force = SCNVector3(-cameraTransform.m31 * power, -cameraTransform.m32 * power + 6, -cameraTransform.m33 * power)
            
            lataNode.physicsBody?.applyForce(force, asImpulse: true)
            lataNode.runAction(rotate)
                                  
            
            sceneView.scene.rootNode.addChildNode(lataNode)
            break;
        case 1:
            guard let lataScene = SCNScene(named: "boladepapel.scn"),
            let lataNode = lataScene.rootNode.childNode(withName: "OrigenPapel", recursively: false)
            else {return}
            let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
            lataNode.transform = cameraTransform
            
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: lataNode, options: [SCNPhysicsShape.Option.collisionMargin: 0.01]))
            
            lataNode.physicsBody = physicsBody
            
            let power = Float(10.0)
            let force = SCNVector3(-cameraTransform.m31 * power, -cameraTransform.m32 * power + 6, -cameraTransform.m33 * power)
            lataNode.physicsBody?.applyForce(force, asImpulse: true)
            sceneView.scene.rootNode.addChildNode(lataNode)
            break;
        case 2:
            guard let lataScene = SCNScene(named: "manzana.scn"),
            let lataNode = lataScene.rootNode.childNode(withName: "OrigenManzana", recursively: false)
            else {return}
            let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
            lataNode.transform = cameraTransform
            
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: lataNode, options: [SCNPhysicsShape.Option.collisionMargin: 0.01]))
            
            lataNode.physicsBody = physicsBody
            
            let power = Float(10.0)
            let force = SCNVector3(-cameraTransform.m31 * power, -cameraTransform.m32 * power + 6, -cameraTransform.m33 * power)
            lataNode.physicsBody?.applyForce(force, asImpulse: true)
            sceneView.scene.rootNode.addChildNode(lataNode)
            break;
        default:
            print("Error")
        }
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer) {
        createBall()
        upNext()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}


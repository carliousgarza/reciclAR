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
    @IBOutlet weak var imgNextBall: UIImageView!
    @IBOutlet weak var btnCredits: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var blurView2: UIView!
    @IBOutlet weak var lbTimeLeft: UILabel!
    
    var nextBall = 0;
    var score = 0;
    var homeNode = SCNNode()
    var homeNode2 = SCNNode()
    var homeNode3 = SCNNode()
    
    var timer:Timer?
    var timeLeft = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.session.pause()
        lbScore.isHidden = true
        btnBack.isHidden = true
        blurView.isHidden = false
        lbTimeLeft.isHidden = true
        setUpScene()
        upNext()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool{
        return false
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
        self.lbScore.text = "Score: \(String(score))"
    }
    
    func scoreKeeperWrong(){
        score = score - 1
        print(score)
        self.lbScore.text = "Score: \(String(score))"
    }
    
    @IBAction func handleStart(_ sender: UIButton) {
        setUpScene()
        btnStart.isHidden = true
        sceneView.isHidden = false
        btnBack.isHidden = false
        btnCredits.isHidden = true
        btnInstructions.isHidden = true
        lbReciclar.isHidden = true
        lbScore.isHidden = false
        imgLogo.isHidden = true
        blurView2.isHidden = true
        blurView.isHidden = true
        lbTimeLeft.isHidden = false
        createTrashCan()
        timeLeft = 30
        lbTimeLeft.text = "Time left: \(timeLeft)"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerFires(){
        timeLeft = timeLeft - 1
        lbTimeLeft.text = "Time left: \(timeLeft)"
        
        if(timeLeft <= 0){
            timer?.invalidate()
            timer = nil
            showScore()
            handleBack(btnBack)
        }
    }
    
    func showScore(){
        performSegue(withIdentifier: "score", sender: self)
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        blurView.isHidden = false
        btnBack.isHidden = true
        sceneView.isHidden = false
        btnStart.isHidden = false
        btnCredits.isHidden = false
        btnInstructions.isHidden = false
        lbReciclar.isHidden = false
        lbScore.isHidden = true
        imgLogo.isHidden = false
        blurView2.isHidden = false
        lbScore.text = String(0)
        lbTimeLeft.isHidden = true
        timeLeft = 30
        score = 0
        timer?.invalidate()
        timer = nil
        
        deleteTrashCan()
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
            let homeNodee = homeScene.rootNode.childNode(withName: "OrigenBAzul", recursively: false)
            else {return}
        homeNodee.position = SCNVector3(0,-4,-10)
        
        guard let homeScene2 = SCNScene(named: "boteverde.scn"),
            let homeNode22 = homeScene2.rootNode.childNode(withName: "OrigenBVerde", recursively: false)
            else {return}
        homeNode22.position = SCNVector3(-3,-4,-10)
        
        
        guard let homeScene3 = SCNScene(named: "botegris.scn"),
            let homeNode33 = homeScene3.rootNode.childNode(withName: "OrigenBGris", recursively: false)
            else {return}
        homeNode33.position = SCNVector3(3,-4,-10)
                
        homeNode = homeNodee
        homeNode2 = homeNode22
        homeNode3 = homeNode33
        
        sceneView.scene.rootNode.addChildNode(homeNode)
        sceneView.scene.rootNode.addChildNode(homeNode2)
        sceneView.scene.rootNode.addChildNode(homeNode3)
    }
    
    func deleteTrashCan() {
        homeNode.removeFromParentNode()
        homeNode2.removeFromParentNode()
        homeNode3.removeFromParentNode()
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
        if(segue.identifier == "score"){
            let scoreView = segue.destination as! ScoreViewController
            scoreView.score = score
        }
    }
    

}


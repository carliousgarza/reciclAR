//
//  ScoreViewController.swift
//  ReciclAR
//
//  Created by Carlos Fernando Garza Martinez on 10/31/19.
//  Copyright © 2019 Carlos Fernando Garza Martinez. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbHighscore: UILabel!
    
    var score : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbScore.text = "You got a score of \(score!)!"
        if(score > 0){
            createParticles()
        }
        else {
            createSadParticles()
        }
        checkAndUpdateScore()
        // Do any additional setup after loading the view.
    }
    
    func checkAndUpdateScore(){
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        if score>highScore {
            UserDefaults.standard.set(score, forKey: "highScore")
            lbHighscore.text = "Highest score achieved: \(score!) "
        }
        else {
            lbHighscore.text = "Highest score achieved: \(highScore)"
        }
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func createSadParticles(){
        view.backgroundColor = UIColor.lightGray
        
        let particleEmitter = CAEmitterLayer()

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: 0)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)

        let purple = makeEmitterCell(color: UIColor.purple)
        let black = makeEmitterCell(color: UIColor.black)
        let gray = makeEmitterCell(color: UIColor.gray)
        
        particleEmitter.emitterCells = [purple, black, gray]

        view.layer.addSublayer(particleEmitter)
    }
    
    func createParticles() {
        let particleEmitter = CAEmitterLayer()

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: 0)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)

        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)

        particleEmitter.emitterCells = [red, green, blue]

        view.layer.addSublayer(particleEmitter)
    }

    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05

        cell.contents = UIImage(named: "rectangle")?.cgImage
        return cell
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

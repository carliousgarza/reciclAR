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
    
    var score : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbScore.text = "You got a score of \(score!)!"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
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

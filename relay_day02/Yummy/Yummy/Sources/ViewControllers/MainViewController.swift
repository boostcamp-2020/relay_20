//
//  MainViewController.swift
//  Yummy
//
//  Created by 남기범 on 2020/08/14.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func functionA(_ sender: Any) {
        guard let rvc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {return}
        
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(rvc, animated: true)
        }
    }
    
    @IBAction func functionB(_ sender: Any) {
        guard let rvc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else {return}
        
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(rvc, animated: true)
        }
    }
    
    @IBAction func functionC(_sender: Any) {
        guard let rvc = self.storyboard?.instantiateViewController(withIdentifier: "RecommandViewController") as? RecommandViewController else {return}
        
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(rvc, animated: true)
        }
    }
}

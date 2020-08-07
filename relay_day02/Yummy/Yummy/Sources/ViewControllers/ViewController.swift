//
//  ViewController.swift
//  Yummy
//
//  Created by woong on 2020/08/07.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit
import Assistant
import NaturalLanguageUnderstanding



class ViewController: UIViewController {
    
    // MARK: - Views
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBAction func touchRequest(_ sender: UIButton) {
        indicator.startAnimating()
        if let urlString = urlTextField.text {
            //requestUrl(urlString: urlString)
            requestCategories(urlString: urlString)
        }
    }
    
    // MARK: - Properties
    
    var categories = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.categoryTableView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }
    
    // MARK: 사용자 키, url 입력
    
    let myKey = ""
    let ibmUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        urlTextField.delegate = self
    }
    
    // MARK: - Methods
    
    func requestCategories(urlString: String) {
        let authenticator = WatsonIAMAuthenticator(apiKey: myKey)
        
        let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(version: "2019-07-12", authenticator: authenticator)
        naturalLanguageUnderstanding.serviceURL = ibmUrl

        let categories = CategoriesOptions(limit: 3)
        let features = Features(categories: categories)
        naturalLanguageUnderstanding.analyze(features: features, url: urlString) {
              response, error in

            guard let analysis = response?.result else {
            print(error?.localizedDescription ?? "unknown error")
            return
            }

            if let categories = analysis.categories {
                self.categories = categories.compactMap { $0.label }
                print(categories)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}

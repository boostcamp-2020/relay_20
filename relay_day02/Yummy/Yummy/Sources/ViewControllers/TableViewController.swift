//
//  TableViewController.swift
//  Yummy
//
//  Created by 남기범 on 2020/08/14.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit
import CoreML
import Vision

class TableViewController: UITableViewController, UISearchBarDelegate {
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    var logoImageView   : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    func didTapRequestButton(text: String?) {
        if let text = text, !text.isEmpty {
            
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        showSearchBar()
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      hideSearchBar()
    }
    
    func showSearchBar() {
      searchBar.alpha = 0
      navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
        self.searchBar.alpha = 1
        }, completion: { finished in
          self.searchBar.becomeFirstResponder()
      })
    }

    func hideSearchBar() {
        navigationItem.setLeftBarButton(searchBarButtonItem, animated: true)
      logoImageView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
        self.navigationItem.titleView = self.logoImageView
        self.logoImageView.alpha = 1
        }, completion: { finished in

      })
    }
    
    func detectImage(image: CIImage) -> String {
        var res = ""
      guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
        fatalError("Loading CoreML model failed")
      }
      let request = VNCoreMLRequest(model: model) { (request, error) in
        guard let results = request.results as? [VNClassificationObservation] else{
          fatalError("Model failed to process image")
        }
        if let topResult = results.first{
            
            res = topResult.identifier
        } else {
        }
      }
      let handler = VNImageRequestHandler(ciImage: image)
      do{
        try handler.perform([request])
      }catch{
        print(error)
      }
        
        return res
    }

}
extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )

        
        
        
        
        // 이미지 여기서 받으면 됩니다.
        let url = URL(string: "https://c402277.ssl.cf1.rackcdn.com/photos/18366/images/carousel_small/Asian_Elephants_WW252891.jpg?1576701543")
        let data = try! Data(contentsOf: url!)
        cell.imageView?.contentMode = .scaleAspectFit
        
        let img = UIImage(data: data)!.resized(toWidth: 100)
        
        cell.imageView?.image = img
        cell.textLabel?.text = detectImage(image: CIImage(image: img!)!)
        
        
        return cell
    }
    
    
}


extension TableViewController {

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        // 스크롤에 따라 네비게이션바가 따라 움직일 때, 텍스트필드도 따라다니게 하기 위해 헤더뷰로 추가함
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequestHeaderView.reuseIdentifier) as? RequestHeaderView else {
//            return nil
//        }
//        headerView.urlTextWhenTouchRequestButton = { [weak self] text in
//            self?.didTapRequestButton(text: text)
//        }
//        urlTextField = headerView.urlTextField
//        urlTextField?.delegate = self
//        headerView.myBackgroundView.backgroundColor = .black
//        return headerView
//    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 클릭하는 순간 선택 해재, 깜빡깜빡 효과
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // textField에서 return을 클릭하면 키보드 내림
        textField.resignFirstResponder()
        return false
    }
}

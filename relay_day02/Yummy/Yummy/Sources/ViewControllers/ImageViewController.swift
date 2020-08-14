//
//  ImageViewController.swift
//  Yummy
//
//  Created by 남기범 on 2020/08/14.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SwiftSoup

class ImageViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var links:[String] = []
    let Queue = DispatchQueue.init(label: "main")
    
    var urlTextField: UITextField?

    
    override func viewDidLoad() {
        
        self.navigationItem.title = "기능 B"
        self.tableView.rowHeight = 100
    
        
        configureTableView()
    }
    
    // MARK: - Initialize
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RequestHeaderView.nib, forHeaderFooterViewReuseIdentifier: RequestHeaderView.reuseIdentifier)
    }
    
    
    // MARK: - Methods
    
    func didTapRequestButton(text: String?) {
        if let text = text, !text.isEmpty {
            
        }
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


extension ImageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )

        // 이미지 여기서 받으면 됩니다.
        
        OperationQueue().addOperation {
            let mainURL = "https://github.com/StoneSSon/Image_Box/issues/1"
            guard let test = URL(string: mainURL) else{
                return
            }
            do{
                let mainPage = try String(contentsOf: test, encoding: .utf8)
                    
                let parseData:Document = try SwiftSoup.parse(mainPage)
                let element1:Element = try parseData.select("#issue-678899656 > div > div.edit-comment-hide > task-lists > table > tbody > tr > td > p > a:nth-child(1) > img").first()!
                let element2:Element = try parseData.select("#issue-678899656 > div > div.edit-comment-hide > task-lists > table > tbody > tr > td > p:nth-child(1) > a:nth-child(3) > img").first()!
                let element3:Element = try parseData.select("#issue-678899656 > div > div.edit-comment-hide > task-lists > table > tbody > tr > td > p:nth-child(1) > a:nth-child(5) > img").first()!
                let element4:Element = try parseData.select("#issue-678899656 > div > div.edit-comment-hide > task-lists > table > tbody > tr > td > p:nth-child(2) > a:nth-child(1) > img").first()!
                
                self.links.append(try element1.attr("src"))
                self.links.append(try element2.attr("src"))
                self.links.append(try element3.attr("src"))
                self.links.append(try element4.attr("src"))
            }catch let error{
                print(error)
            }
            let url = URL(string: self.links[indexPath.row])
            let data = try! Data(contentsOf: url!)
            let img = UIImage(data: data)?.resized(toWidth: 70)
            
            OperationQueue.main.addOperation {
                cell.imageView?.contentMode = .scaleAspectFit
                cell.imageView?.image = img
                cell.textLabel?.text = self.detectImage(image: CIImage(image: img!)!)
            }
        }
        
        return cell
    }
    
    
}


extension ImageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // 스크롤에 따라 네비게이션바가 따라 움직일 때, 텍스트필드도 따라다니게 하기 위해 헤더뷰로 추가함
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequestHeaderView.reuseIdentifier) as? RequestHeaderView else { return nil }
        headerView.urlTextWhenTouchRequestButton = { [weak self] text in
            self?.didTapRequestButton(text: text)
        }
        urlTextField = headerView.urlTextField
        urlTextField?.delegate = self
        headerView.myBackgroundView.backgroundColor = .white
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 클릭하는 순간 선택 해재, 깜빡깜빡 효과
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




extension ImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // textField에서 return을 클릭하면 키보드 내림
        textField.resignFirstResponder()
        return false
    }
}


extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

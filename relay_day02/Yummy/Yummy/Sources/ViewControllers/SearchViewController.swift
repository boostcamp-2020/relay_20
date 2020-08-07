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

class SearchViewController: UIViewController {
    
    // MARK: - Views
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryTableView: UITableView!
    /**
     url을 입력하는 TextField
     RequestHeaderView에 들어있는 걸 가져옴
     */
    var urlTextField: UITextField?
    
    // MARK: - Properties
    
    /**
     검색 결과를 저장하는 카테고리 현재는 카테고리만 String으로 받고 있음
     실제 result에는 score: Double도 있음
     */
    var categories = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.categoryTableView.reloadData()
            }
        }
    }
    
    // MARK: 사용자 키, url 입력
    
    private let myKey = ""
    private let ibmUrl = ""
    
    // MARK: - App Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    // MARK: - Initialize
    
    func configureTableView() {
        categoryTableView.delegate = self
        categoryTableView.register(RequestHeaderView.nib, forHeaderFooterViewReuseIdentifier: RequestHeaderView.reuseIdentifier)
    }
    
    // MARK: - Methods
    
    func didTapRequestButton(text: String?) {
        if let text = text, !text.isEmpty {
            updateViewsWhenStartSearching()
            requestUrlToWatson(urlString: text)
        }
    }
    
    func updateViewsWhenStartSearching() {
        indicator.startAnimating()
        urlTextField?.resignFirstResponder()
    }
    
    /**
     Watson NaturalLanguageUnderstanding api에 요청하는 메소드.
     검색할 urlString 과 출력 개수를 입력받는다.
     default limit = 20
     */
    func requestUrlToWatson(urlString: String, limit: Int = 20) {
        let authenticator = WatsonIAMAuthenticator(apiKey: myKey)
        
        let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(version: "2019-07-12", authenticator: authenticator)
        naturalLanguageUnderstanding.serviceURL = ibmUrl
        
        let categories = CategoriesOptions(limit: limit)
        let features = Features(categories: categories)
        naturalLanguageUnderstanding.analyze(features: features, url: urlString) {
              response, error in

            // 검색 결과
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

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        // 우선은 셀 커스터마이징 없이 기본 라벨에 카테고리만 출력하고 있음
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
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

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // textField에서 return을 클릭하면 키보드 내림
        textField.resignFirstResponder()
        return false
    }
}

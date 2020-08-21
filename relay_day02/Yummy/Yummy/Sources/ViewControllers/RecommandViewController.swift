//
//  RecommandViewController.swift
//  Yummy
//
//  Created by 김근수 on 2020/08/21.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class RecommandViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	let recommandManager = RecommendManager.shared
	var keywords: [String] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.delegate = self
		let keyword = recommandManager.getRankedKeywords()
		SearchAPI.shared.request(keyword: keyword.first!) { keywords in
			self.keywords = keywords
			self.tableView.reloadData()
		}
		
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
	
}

extension RecommandViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return keywords.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "recommandCell", for: indexPath)
		
		cell.textLabel?.text = keywords[indexPath.row]
		cell.textLabel?.numberOfLines = 0
		
		return cell
	}
	
	
}

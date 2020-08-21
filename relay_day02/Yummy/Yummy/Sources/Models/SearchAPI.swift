//
//  SearchAPI.swift
//  Yummy
//
//  Created by Oh Donggeon on 2020/08/21.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation
import Foundation
import Alamofire

struct Response: Codable {
	let display: Int
	let items: [Items]
	let lastBuildDate: String
	let start: Int
	let total: Int
}

struct Items: Codable {
	let title: String
	let link: String
	let description: String
}

class SearchAPI {
	func request(keyword: String) {
		var url = "https://openapi.naver.com/v1/search/webkr.json?query="
		var headers: HTTPHeaders = [:]
		
		url.append(keyword)
		
		headers["X-Naver-Client-Id"] = "flShl6kTbPdSLPwzJ7W4"
		headers["X-Naver-Client-Secret"] = "w4Bzt8bwf9"
		
		AF.request(url, method: .get,
				   encoding: JSONEncoding.default,
				   headers: headers).responseString { (response) in
					
					let decoder = JSONDecoder()
					var data = response.value?.data(using: .utf8)
					
					if let data = data, let myInfo = try? decoder.decode(Response.self, from: data) {
						print(myInfo.items)
					} else {
						print("decode실패")
					}
		}
	}
}
import Foundation
import Alamofire

struct Response: Codable {
	let display: Int
	let items: [Items]
	let lastBuildDate: String
	let start: Int
	let total: Int
}

struct Items: Codable {
	let title: String
	let link: String
	let description: String
}

class SearchAPI {
	func request(keyword: String) {
		var url = "https://openapi.naver.com/v1/search/webkr.json?query="
		var headers: HTTPHeaders = [:]
		
		url.append(keyword)
		
		headers["X-Naver-Client-Id"] = "flShl6kTbPdSLPwzJ7W4"
		headers["X-Naver-Client-Secret"] = "w4Bzt8bwf9"
		
		AF.request(url, method: .get,
				   encoding: JSONEncoding.default,
				   headers: headers).responseString { (response) in
					
					let decoder = JSONDecoder()
					var data = response.value?.data(using: .utf8)
					
					if let data = data, let myInfo = try? decoder.decode(Response.self, from: data) {
						print(myInfo.items)
					} else {
						print("decode실패")
					}
		}
	}
}

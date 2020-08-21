//
//  SearchAPI.swift
//  Yummy
//
//  Created by Oh Donggeon on 2020/08/21.
//  Copyright © 2020 woong. All rights reserved.
//
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
	public static let shared = SearchAPI()
	private init() { }
	func request(keyword: String, completion: @escaping (([String]) -> Void)) {
		var url = "https://openapi.naver.com/v1/search/webkr.json?query="
		var headers: HTTPHeaders = [:]
		var links: [String] = []
		url.append(keyword)
		headers["X-Naver-Client-Id"] = "flShl6kTbPdSLPwzJ7W4"
		headers["X-Naver-Client-Secret"] = "w4Bzt8bwf9"
		AF.request(url, method: .get,
		encoding: JSONEncoding.default,
		headers: headers).responseString { (response) in
			let decoder = JSONDecoder()
			let data = response.value?.data(using: .utf8)
			if let data = data, let myInfo = try? decoder.decode(Response.self, from: data) {
				myInfo.items.forEach({ links.append($0.link) })
				DispatchQueue.main.async {
					completion(links)
				}
			} else {
				print("decode실패")
			}
		}
	}
}

//class SearchAPI {
//	func request(keyword: String) -> [String] {
//		var url = "https://openapi.naver.com/v1/search/webkr.json?query="
//		var headers: HTTPHeaders = [:]
//		var links: [String] = []
//
//		url.append(keyword)
//
//		headers["X-Naver-Client-Id"] = "flShl6kTbPdSLPwzJ7W4"
//		headers["X-Naver-Client-Secret"] = "w4Bzt8bwf9"
//
//		DispatchQueue(label: "Search queue").sync {
//			AF.request(url, method: .get,
//					   encoding: JSONEncoding.default,
//					   headers: headers).responseString { (response) in
//
//						let decoder = JSONDecoder()
//						let data = response.value?.data(using: .utf8)
//
//						if let data = data, let myInfo = try? decoder.decode(Response.self, from: data) {
//							myInfo.items.forEach({ links.append($0.link) })
//						} else {
//							print("decode실패")
//						}
//			}
//		}
//
//		return links
//	}
//}

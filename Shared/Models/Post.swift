//
//  Post.swift
//  alpha-app
//
//  Created by Lincoln Anders on 9/7/21.
//

import Foundation
import SerializedSwift
import SwiftUI

class Post: BackedObject {
	@Serialized var title: String
	@Serialized var body: String
}

class PostController {
	public static var baseURL = "/posts"
	public static var all = Observable<[Post]>()
	
	static func fetchAll() {
		if all.value == nil {
			WebCommunicator.get(endpoint: baseURL, destination: all)
		}
	}
	
	static func fetch(id: Int) -> Observable<BackedObject> {
		let result = Observable<BackedObject>()
		WebCommunicator.get(endpoint: "\(baseURL)/\(id)", destination: result)
		return result
	}
	
	static func create(title: String, body: String) {
		WebCommunicator.post(endpoint: baseURL, body: [ "post" : [ "title": title, "body": body ] ], completion: { (_: Result<Post>) in
			return
		})
	}
	
	static func retain(_ item: Post) {
		guard let allVal = all.value else {
			all = Observable<[Post]>(value: [item])
			return
		}
		guard allVal.contains(item) else { return }
		
		all.value!.append(item)
	}
}

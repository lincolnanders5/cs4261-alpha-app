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
			WebCommunicator.get(endpoint: baseURL, destination: PostController.all)
		}
	}
	
	static func fetch(id: Int) -> Observable<Post> {
		let result = Observable<Post>()
		WebCommunicator.get(endpoint: "\(baseURL)/\(id)", destination: result)
		return result
	}
}

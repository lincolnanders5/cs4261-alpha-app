//
//  PostCreateDetail.swift
//  alpha-app
//
//  Created by Lincoln Anders on 9/7/21.
//

import SwiftUI

struct PostCreateDetail: View {
	@ObservedObject var pTitle = Observable<String>()
	@ObservedObject var pBody  = Observable<String>()
	
    var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			TextField("Title", text: pTitle.toBinding(defaultValue: ""))
				.font(.title)
			TextField("Body", text: pBody.toBinding(defaultValue: ""))
			
			Spacer()
			
			Button("Post", action: {
				let body = [ "post": [ "title": pTitle.value ?? "", "body": pBody.value ?? "" ] ]
				WebCommunicator.post(endpoint: "/posts", body: body, completion: { (post: Result<Post>) in
					guard let createdPost = post.value else {
						print("Could not create post")
						return
					}
					
					pTitle.value = ""
					pBody.value = ""
					
					PostController.retain(createdPost)
					PostController.fetchAll()
					return
				})
			})
		}.padding()
    }
}

struct PostCreateDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostCreateDetail()
    }
}

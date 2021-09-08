//
//  PostList.swift
//  alpha-app
//
//  Created by Lincoln Anders on 9/7/21.
//

import SwiftUI

struct PostList: View {
	@ObservedObject var fetch = PostController.all
	
    var body: some View {
		List (fetch.value ?? [Post]()) { (model) in
			PostListItem(model: model)
		}.onAppear(perform: {
			PostController.fetchAll()
		})
    }
}

struct PostList_Previews: PreviewProvider {
    static var previews: some View {
        PostList()
    }
}

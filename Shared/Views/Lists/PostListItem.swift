//
//  PostListItem.swift
//  alpha-app
//
//  Created by Lincoln Anders on 9/7/21.
//

import SwiftUI

struct PostListItem: View {
	@State var model: Post
	
	var body: some View {
		VStack(alignment: .leading){
			HStack(alignment: .top) {
				Text(model.title)
					.font(.headline)
					.lineLimit(1)
				Spacer()
				Text(model.updatedAt.toRelative())
					.foregroundColor(.gray)
					.font(.caption)
			}
			Text(model.body)
		}
	}
}

//struct PostListItem_Previews: PreviewProvider {
//	static var fetch = PostController.fetch(id: 1)
//    static var previews: some View {
//		PostListItem(model: fetch.value ?? Post())
//    }
//}

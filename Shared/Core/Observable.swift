//
//  Observable.swift
//  alpha-app
//
//  Created by Lincoln Anders on 9/7/21.
//

import Foundation
import Combine
import SwiftUI

public class Observable<T>: ObservableObject {
	@Published var value: T? {
		willSet { objectWillChange.send() }
	}
	
	init(value: T) { self.value = value }
	init() { self.value = nil }
	
	func toBinding(defaultValue: T) -> Binding<T> {
		return Binding(
			get: { return self.value ?? defaultValue },
			set: { self.value = $0 }
		)
	}
	
	func toUnsafeBinding() -> Binding<T> {
		return Binding(
			get: { return self.value! },
			set: { self.value = $0 }
		)
	}
}

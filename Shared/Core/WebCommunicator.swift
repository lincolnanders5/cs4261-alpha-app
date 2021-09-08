//
//  WebCommunicator.swift
//  alpha-app
//
//  Created by Lincoln Anders on 9/7/21.
//

import Foundation

let API_BASE = ProcessInfo.processInfo.environment["API_URI"] ?? "https://cs4261-landers8-alpha.herokuapp.com"

enum Result<T> {
	case success(value: T)
	case failure(errorObj: [String: String])
	
	var value: T? {
		switch self {
		case .success(let value): return value
		case .failure: return nil
		}
	}
}

extension Encodable {
	func toJSONData() -> Data? { try? JSONEncoder().encode(self) }
}

struct WebCommunicator {
	static let decoder = initDecoder()
	
	static func get<T: Decodable>(endpoint: String, completion: @escaping (Result<T>) -> Void) {
		let api_url = URL(string: API_BASE + endpoint + ".json")!
		var request = URLRequest(url: api_url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
		
		WebCommunicator.sendRequest(request: request, completion: completion)
	}
	
	static func get<T: Decodable>(endpoint: String, destination: Observable<T>) {
		WebCommunicator.get(endpoint: endpoint, completion: { (result: Result<T>) in
			guard let value = result.value else { return }
			destination.value = value
		})
	}
	
	static func post<T: Decodable>(endpoint: String, body: Encodable?, completion: @escaping (Result<T>) -> Void) {
		let api_url = URL(string: API_BASE + endpoint + ".json")!
		var request = URLRequest(url: api_url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
		
		guard let jsonData = body?.toJSONData() else {
			assertionFailure()
			return completion(.failure(errorObj: ["error": "Could not encode JSON properly"]))
		}
		request.httpBody = jsonData
		
		WebCommunicator.sendRequest(request: request, completion: completion)
	}
	
	private static func sendRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T>) -> Void) {
		//		print("WC.sendRequest: Requesting data via \(request.httpMethod ?? "UNKNOWN") from URL '\(request.url?.absoluteString ?? "undefined location")' into \(T.self)")
		URLSession.shared.dataTask(with: request) { (data, response, dataError) in
			if (dataError != nil) {
				completion(.failure(errorObj: [ "" : "" ]))
				return
			}
			
			if let eventData = data {
				do {
					let decodedData: T = try decoder.decode(T.self, from: eventData)
					
					DispatchQueue.main.async {
						// print("COMPLETED")
						completion(.success(value: decodedData))
					}
				} catch {
					do {
						let decodedError: [String: String] = try decoder.decode([String: String].self, from: eventData)
						print("\(request.httpMethod ?? "UNKNOWN") ERROR:\n"
								+ "\t- URL:   \(request.url?.absoluteString ?? "undefined location")\n"
								+ "\t- Error: \(decodedError)")
						completion(.failure(errorObj: [ "" : "" ]))
					} catch {
						let jsonResponse = try? JSONSerialization.jsonObject(with: eventData, options: [])
						print("UNKNOWN ERROR:\n"
								+ "\t- URL: \(request.url?.absoluteString ?? "undefined location") (\(request.httpMethod ?? "UNKNOWN"))\n"
								+ "\t- Error: \(error)\n"
								+ "\t- JSON: \(jsonResponse ?? "None")")
						completion(.failure(errorObj: [ "" : "" ]))
					}
				}
			} else {
				print("ERROR IN PARSING INTO OBJECT")
				completion(.failure(errorObj: [ "" : "" ]))
			}
		}.resume()
	}
	
	private static func initDecoder() -> JSONDecoder {
		let newDecoder = JSONDecoder()
		newDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
		newDecoder.keyDecodingStrategy = .useDefaultKeys
		return newDecoder
	}
}

import SerializedSwift

class BackedObject: Serializable, Identifiable, Equatable {
	@Serialized(default: 0)
	var id: Int
	
	@Serialized("created_at", default: Date())
	var createdAt: Date
	
	@Serialized("updated_at", default: Date())
	var updatedAt: Date
	
	required init() {}
	
	static func == (lhs: BackedObject, rhs: BackedObject) -> Bool {
		lhs.id == rhs.id && lhs.createdAt == rhs.createdAt
	}
}

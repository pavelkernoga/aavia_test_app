//
//  RequestManager.swift
//  ExpenseTracker
//
//  Created by pavel on 9.06.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

struct RequestManager {
    
    static let shared = RequestManager()
    let decoder = JSONDecoder()

    func makePostCall(value: Double, fromCurrency: String, toCurrency: String, completion: @escaping ((ResponseData?) -> Void)) {
        let url = URL(string: "https://elementsofdesign.api.stdlib.com/aavia-currency-converter@dev/")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let postString = "amount=\(value)&to_currency=\(toCurrency)&from_currency=\(fromCurrency)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            do {
                // dataResponse received from a network request
                if let data = data {
                    let model = try decoder.decode(ResponseData.self, from: data)
                    print(model)
                    completion(model)
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}

//
//  ViewController.swift
//  IsmartvPlayer-swift
//
//  Created by huibin on 31/05/2018.
//  Copyright © 2018 ___HUIBIN___. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    let SKY_HOST: String = "http://sky.tvxio.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        accountActive()
//        makeGetCall()

        trustGetLicence()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func accountActive() -> Void {
        let url: URL? = URL(string: "https://www.baidu.com/")

        if let u = url {
            let urlRequest: URLRequest = URLRequest(url: u)
            let urlSession = URLSession.shared
            let task: URLSessionDataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    print("error calling GET")
                    print(error!)
                    return
                }

                guard let r = data else {
                    print("Error: did not receive data")
                    return
                }

                do {
                    if let d = data {
                        let result = String(data: d, encoding: String.Encoding.utf8)
                        print("this is: \(result!)")
                    }
                }

            }
            task.resume()
        }
    }


    func makeGetCall() {
        // Set up the URL request
        let todoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)

        // set up the session
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)

        let session = URLSession.shared

        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)

                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }


    func trustGetLicence() -> Void {
        let fingerprint: String = "fingerprint"
        let sn: String = "sn"
        let manufacture: String = "manufacture"
        let code: String = "code"

        let api = SKY_HOST + "/trust/get_licence/"

        guard let url = URL(string: api) else {
            return
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "POST"

        let parameters = ["fingerprint": fingerprint, "sn": sn, "manufacture": manufacture, "code": code]

        let body = getPostString(params: parameters)

//        urlRequest.httpBody = body.data(using: .utf8)

        let session = URLSession.shared

        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) -> Void in

            guard  error == nil else {
                print(error)
                return
            }

            guard let d = data else {

                return
            }


            do {

                if let r = response {
                    print("response: \(r)")
                }


                if let result = data {
                    print("result is: \(String(data: result, encoding: .utf8))")
                }

            } catch {
                print(error)
            }
        }

        task.resume()
    }


    func makePostCall() {
        let todosEndpoint: String = "https://jsonplaceholder.typicode.com/todos"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        let newTodo: [String: Any] = ["title": "My First todo", "completed": false, "userId": 1]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                        options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                print("The todo is: " + receivedTodo.description)

                guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
            } catch {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }

    func getPostString(params: [String: Any]) -> String {
        var data = [String]()
        for (key, value) in params {
            data.append(key + "=\(value)")
        }

        return data.map {
            String($0)
        }.joined(separator: "&")
    }

}

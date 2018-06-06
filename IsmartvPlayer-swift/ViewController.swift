//
//  ViewController.swift
//  IsmartvPlayer-swift
//
//  Created by huibin on 31/05/2018.
//  Copyright © 2018 ___HUIBIN___. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        accountActive()
//        makeGetCall()
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
}

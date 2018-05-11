//
//  SampleAlamofireViewController.swift
//  CocoaPodTests
//
//  Created by Douglas Frari on 11/05/18.
//  Copyright © 2018 CESAR School. All rights reserved.
//

import UIKit
import Alamofire

class SampleAlamofireViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sample Alamofire"
        self.navigationItem.largeTitleDisplayMode = .always
        
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            // original url request
            print("Request: \(String(describing: response.request))")
            // http url response
            print("Response: \(String(describing: response.response))")
            // response serialization result
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

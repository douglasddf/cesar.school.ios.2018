//
//  REST.swift
//  Carangas
//
//  Created by Douglas Frari on 25/04/2018.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}

class REST {
    // URLs que tem https sao aceitas no iOS por padrao. Se necessitar usar http (sem s), talvez
    // seja necessario atualizar a configuracao no Info.plist
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let fipeBrandsURL = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
    
    // session criada automaticamente e disponivel para reusar
    // private static let session = URLSession.shared
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let session = URLSession(configuration: configuration) // URLSession.shared
    
    
    // os parametros do metodo tem 2 closures e precisam reter o seu conteudo @escaping (passagem por referencia)
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        
        // objeto de requisicao automatico é criado para GET, outros verbos precisamos criar o
        // objeto de Request para mudar para POST, PUT...
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            // tarefa criada, mas nao processada
            
            if error == nil {
                
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    
                    // obter o valor de data
                    guard let data = data else {return}
                    
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                        
                    } catch {
                        onError(.invalidJSON)
                    }
                    
                } else {
                    onError(.responseStatusCode(code: response.statusCode))
                }
                
                
            } else {
                print(error.debugDescription)
                onError(.taskError(error: error!))
            }
            
        }
        dataTask.resume()
    }
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        
        guard let url = URL(string: fipeBrandsURL) else {
            onComplete(nil)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            // tarefa criada, mas nao processada
            
            if error == nil {
                
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200 {
                    
                    // obter o valor de data
                    guard let data = data else {return}
                    
                    do {
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        onComplete(brands)
                        
                    } catch {
                        onComplete(nil)
                    }
                    
                } else {
                    onComplete(nil)
                }
                
                
            } else {
                print(error.debugDescription)
                onComplete(nil)
            }
            
        }
        dataTask.resume()
    }
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    private class func applyOperation(car: Car, operation: RESTOperation , onComplete: @escaping (Bool) -> Void ) {
        
        // o endpoint do servidor para update é: URL/id
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        
        var request = URLRequest(url: url)
        var httpMethod: String = ""
        
        switch operation {
            case .delete:
                httpMethod = "DELETE"
            case .save:
                httpMethod = "POST"
            case .update:
                httpMethod = "PUT"
        }
        request.httpMethod = httpMethod
        
        // transformar objeto para um JSON, processo contrario do decoder -> Encoder
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                // verificar e desembrulhar em uma unica vez
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                
                // ok
                onComplete(true)
                
            } else {
                onComplete(false)
            }
        }
        
        dataTask.resume()
    }
    
}










//
//  Task.swift
//  YungNetworkTool
//
//  Created by daye on 2020/12/19.
//

// accoding to Tiercel

import UIKit
import Alamofire

public typealias TaskParameters = [String: Any]

public typealias TaskHTTPHeaders = [String: String]

public protocol TaskParameterEncoding:ParameterEncoding {
    
}

open class Task<TaskType> {
    
    enum InterruptType {
        case manual
        case error(_ error: Error)
        case statusCode(_ statusCode: Int)
    }
    
    public enum TaskHTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    
    let url:String
    
    let method:TaskHTTPMethod
    
    var parameters:TaskParameters?
    
    let encoding:ParameterEncoding
    
    var headers:TaskHTTPHeaders?

    private var request:Request?
    
    private let AF = SessionManager.default

    init(url:String,
         method:TaskHTTPMethod = .get,
         parameters:TaskParameters?,
         encoding:ParameterEncoding = URLEncoding.default,
         headers:TaskHTTPHeaders?) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
    
    func resume() {
        request?.resume()
    }
    
    func suspend() {
        request?.suspend()
    }
    
    func cancel() {
        request?.cancel()
    }
    
    private func createRequest() {
        let method = HTTPMethod(rawValue: self.method.rawValue) ?? HTTPMethod.get
        request = AF.request(self.url, method: method, parameters: self.parameters, encoding: self.encoding, headers: self.headers)
//        request?.responseJSON(completionHandler: { (json) in
//
//        })
    }
}

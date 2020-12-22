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
    
    public enum InterruptType {
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
    
    
    public let url:String
    
    public let method:TaskHTTPMethod
    
    public var parameters:TaskParameters?
    
    public let encoding:ParameterEncoding
    
    public var headers:TaskHTTPHeaders?

    public var request:Request?
    
    public let AF = SessionManager.default
    
    public init(url:String,
         method:TaskHTTPMethod = .get,
         parameters:TaskParameters? = nil,
         encoding:ParameterEncoding = URLEncoding.default,
         headers:TaskHTTPHeaders? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
    
    public func resume() {
        if request == nil {
            request = create()
        }
        request?.resume()
    }
    
    public func suspend() {
        request?.suspend()
    }
    
    public func cancel() {
        request?.cancel()
    }
    
    func create() ->Request {
        let method = HTTPMethod(rawValue: self.method.rawValue) ?? HTTPMethod.get
        return AF.request(self.url, method: method, parameters: self.parameters, encoding: self.encoding, headers: self.headers)
    }
}

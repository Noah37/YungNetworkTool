//
//  DataTask.swift
//  YungNetworkTool
//
//  Created by daye on 2020/12/21.
//

import UIKit
import Alamofire

open class DataTask: Task<DataTask> {
    
    public var resultHandler:TaskResultHandler?
    
    public var responseData:Data? { return response?.value }
    
    private var response:DataResponse<Data>?
    
    override public func resume() {
        super.resume()
        guard let req = request as? DataRequest else { return }
        req.responseData { [weak self] (data) in
            self?.response = data
            self?.resultHandler?(data.value, data.error)
        }
    }
}

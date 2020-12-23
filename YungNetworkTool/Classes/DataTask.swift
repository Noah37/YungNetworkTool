//
//  DataTask.swift
//  YungNetworkTool
//
//  Created by daye on 2020/12/21.
//

import UIKit
import Alamofire

open class DataTask: Task<DataTask> {
    
    public var resultHandler:TaskResultHandler? {
        didSet { dataResult(closure: self.resultHandler) }
    }
    
    public var responseData:Data? { return response?.value }
    
    private var response:DataResponse<Data>?
    
    override public func resume() {
        super.resume()
    }
    
    private func dataResult(closure:TaskResultHandler?) {
        guard let resultHandler = closure else { return }
        guard let req = request as? DataRequest else { return }
        req.responseData { [weak self] (responseData) in
            self?.response = responseData
            resultHandler(responseData.value, responseData.error)
        }
    }
}

//
//  DataTask.swift
//  YungNetworkTool
//
//  Created by daye on 2020/12/21.
//

import UIKit
import Alamofire

open class DataTask: Task<DataTask> {
    
    
    private var response:DataResponse<Data>?
    
    override public func resume() {
        super.resume()
        guard let req = request as? DataRequest else { return }
        req.responseData { [weak self] (data) in
            self?.response = data
        }
    }
}

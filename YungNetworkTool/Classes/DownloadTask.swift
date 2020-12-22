//
//  DownloadTask.swift
//  YungNetworkTool
//
//  Created by daye on 2020/12/22.
//

import UIKit
import Alamofire

public typealias TaskProgressHandler = Request.ProgressHandler

public typealias TaskResultHandler = (Data?, Error?)->Void

public class DownloadTask: Task<DownloadTask> {
    
    public var destinationURL:URL?
    
    public var fileName:String { return destinationURL?.lastPathComponent ?? (url as NSString).lastPathComponent }
    
    public var progressHandler:TaskProgressHandler? {
        didSet { downloadProgress(closure: self.progressHandler) }
    }
    
    open var progress: Progress? {
        if let req = request as? DownloadRequest  {
            return req.progress
        }
        return nil
    }
    
    public var startRequestsImmediately:Bool = false {
        didSet { AF.startRequestsImmediately = startRequestsImmediately }
    }
    
    public var resultHandler:TaskResultHandler? {
        didSet { downloadResult(closure: self.resultHandler) }
    }
    
    public var responseData:Data? { return response?.resumeData }
    
    private var response:DownloadResponse<Data>?

    override public func resume() {
        super.resume()
        guard let req = request as? DownloadRequest else { return }
//        req.responseData { (responseData) in
//            self.response = responseData
//        }
        req.resume()
    }
    
    override func create() -> Request {
        let method = HTTPMethod(rawValue: self.method.rawValue) ?? HTTPMethod.get
        
        let suggestDownloadFileDestination:DownloadRequest.DownloadFileDestination = { [unowned self] (url, response) in
            if let desURL = self.destinationURL {
                return (desURL, [])
            }
            let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

            if !directoryURLs.isEmpty {
                return (directoryURLs[0].appendingPathComponent(response.suggestedFilename!), [])
            }
            return (url, [])
        }
        return AF.download(self.url, method: method, parameters: parameters, encoding: encoding, headers:headers, to: suggestDownloadFileDestination)
    }
    
    private func downloadProgress(queue: DispatchQueue = DispatchQueue.main, closure:TaskProgressHandler?) {
        guard let progressHandler = closure else { return }
        guard let req = request as? DownloadRequest else { return }
        req.downloadProgress(queue: queue, closure: progressHandler)
    }
    
    private func downloadResult(closure:TaskResultHandler?) {
        guard let resultHandler = closure else { return }
        guard let req = request as? DownloadRequest else { return }
        req.responseData { (responseData) in
            self.response = responseData
            resultHandler(responseData.value, responseData.error)
        }
    }
}

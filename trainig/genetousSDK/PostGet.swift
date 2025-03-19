//
//  PostGet.swift
//  genetousSDK
//
//  Created by mac on 10.3.2016.
//

import Foundation
import Network
import UIKit
protocol completionHandler{
    func onHttpFinished(response:response!)
}
public protocol uploadProgress {
    func progress(uploadProgress:Float)
}
public enum REQUEST_METHODS {
    case POST
    case GET
}

public enum RETURN_TYPE {
    case STRING
    case MAPPER
    case JSONOBJECT
    case JSONARRAY
    case DATA
}

public enum POST_TYPE {
    case MULTIPART
    case JSON
}

public enum URL_TYPE:CustomStringConvertible {
    case addUniqueCollection
    case addCollection
    case updateCollection
    case deleteCollection
    case addRelation
    case getCollections
    case getRelations
    case isUnique
    case createSecureLink
    case uploadFile
    case deleteFile
    case getFileList
    case client
    case auth
    case verify
    case killToken
    case login
    case getUserComment
    case getTrainerComment
    case search
    case getFeatured
    case getFilters
    case insertData
    case addMultiCollection
    case getUpcoming
    case getUserBought
    case getUserSoldDates
    case getTrainerSold
    case getAdsFromSearchService
    case getTrainerUpcoming
    case updateSearchService
    case createMeetingToken
    case refreshToken
    
    public var description : String {
        switch self {
        case .addUniqueCollection: return "dataservice/add/unique/collection"
        case .addCollection: return "dataservice/add/collection"
        case .updateCollection: return "dataservice/update/collection"
        case .deleteCollection: return "dataservice/delete/collection"
        case .addRelation: return "dataservice/add/relation"
        case .getCollections: return "dataservice/get/collections"
        case .getRelations: return "dataservice/get/relations"
        case .isUnique: return "dataservice/check/unique"
        case .createSecureLink: return "dataservice/create/slink"
        case .uploadFile: return "osservice/upload"
        case .deleteFile: return "osservice/delete"
        case .getFileList: return "osservice/list/objects"
        case .client: return "authservice/client"
        case .auth: return "authservice/auth"
        case .verify: return "authservice/verify"
        case .killToken: return "authservice/logout"
        case .login: return "dataservice/login"
        case .getUserComment: return "dataservice/execute/getCommentsByUserId"
        case .getTrainerComment: return "dataservice/execute/getCommentsByTrainerId"
        case .search: return "searchservice/search"
        case .getFeatured: return "searchservice/featured"
        case .getFilters: return "searchservice/filters"
        case .insertData: return "searchservice/create"
        case .addMultiCollection: return "dataservice/add/multicollection"
        case .getUpcoming: return "dataservice/execute/getUpcoming"
        case .getUserBought: return "dataservice/execute/getUserBought"
        case .getUserSoldDates: return "dataservice/execute/getSoldDates"
        case .getTrainerSold: return "dataservice/execute/getTrainerSold"
        case .getAdsFromSearchService: return "searchservice/get/ads"
        case .getTrainerUpcoming: return "dataservice/execute/getTrainerUpcoming"
        case .updateSearchService: return "searchservice/update"
        case .createMeetingToken: return "agoraservice/create/meeting"
        case .refreshToken: return "authservice/refresh"
        }
    }
}

public typealias OnComplete = (_ response:response?)->Void
public typealias OnComplete2 = (_ response:Data?)->Void
var getServerResponseForUrlCallback: OnComplete!
var getServerResponseForUrlCallback2: OnComplete2!
public class PostGet:NSObject,URLSessionTaskDelegate{
    
    internal init(host: String? = nil, url_type: String? = nil, jsonPostData: Any? = nil, parameters: [Any]? = nil, method: REQUEST_METHODS? = nil, post_type: POST_TYPE? = nil, token: String? = nil, return_type: RETURN_TYPE? = nil, requestCode: Int? = nil, postFile: URL? = nil, delegate: uploadProgress? = nil) {
        self.host = host
        self.url_type = host! + url_type!
        self.jsonPostData = jsonPostData
        self.parameters = parameters
        self.method = method
        self.post_type = post_type
        self.token = token
        self.return_type = return_type
        self.requestCode = requestCode
        self.postFile = postFile
        self.delegate = delegate
    }
    
    var host:String!
    var url_type:String!
    var jsonPostData:Any!
    var parameters:[Any]!
    var method:REQUEST_METHODS!
    var post_type:POST_TYPE!
    var token:String!
    var return_type:RETURN_TYPE!
    var requestCode:Int!
    var postFile:URL!
    var delegate:uploadProgress!
    public static var no_connection = "No Internet Connection!"
    
    func isInternetAvailable(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
            monitor.cancel()
        }
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        if(self.delegate != nil){
            self.delegate.progress(uploadProgress: uploadProgress)
        }
    }
    var ttt = 0
    public func process(withBlock callback: @escaping OnComplete) {
        isInternetAvailable { isConnected in
            if isConnected {
//                if self.ttt < 1  {
//                    self.token = "eyJhbGciOiJIUzI1NiJ9.eyJvcmdhbml6YXRpb25JZCI6IjY0Y2NlNjVmOTdmYjMwN2FkNmYzZDFlOSIsImNsaWVudElkIjoiN2QwMGVlNGEyZmNjYjNhYzY2N2E0YmQ3Iiwicm9sZSI6Imd1ZXN0IiwiaWQiOiI2N2QxNjlkOWYwODBhNzMxODJhYTc2MjEiLCJhcHBsaWNhdGlvbklkIjoiZDM1MjgwNTgtYzE2MS00ZjExLTgzMDQtMGUwMGY3N2RmYmRlIiwic3ViIjoiN2QwMGVlNGEyZmNjYjNhYzY2N2E0YmQ3IiwiaWF0IjoxNzQxNzc3MzcwLCJleHAiOjE3NDE4NjM3NzB9.XaBihCC-q3nndBdBvXgTF3do_VFn97EdF7_AvM9-_Kg"
//                    self.ttt += 1
//                }
                
                
                self.processMain {response in
                    callback(response)
                }
            } else {
                let res = responseBuilder()
                res.setExceptionData("No Internet Connection!")
                    .setResponseCode(777)
                callback(res.createResponse())
                print("❌ İnternet yok, API çağrısı iptal edildi.")
                return
            }
        }
    }
    static var shown:Bool = false
    public static func noInterneterror(v:UIViewController){
        if(shown){return}
        shown = true
        Functions.createAlertStatic(self: v, title: String(localized:"error"), message: String(localized:"no_internet"), yesNo: false, alertReturn: { result in
            shown = false
        })
    }
    func processMain(withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        
        let res = responseBuilder()
        if(post_type != POST_TYPE.MULTIPART){
            let defaultConfigObject: URLSessionConfiguration = URLSessionConfiguration.default
            let delegateFreeSession: URLSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
            let url: URL = URL(string: url_type)!
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = self.method == REQUEST_METHODS.GET ? "GET" : "POST"
            print(self.method == REQUEST_METHODS.GET ? "GET" : "POST")
            if((self.method == REQUEST_METHODS.POST
                || self.method == nil) && jsonPostData != nil){
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonPostData, options: .prettyPrinted)
                    let d=try JSONSerialization.data(withJSONObject: jsonPostData, options: .prettyPrinted)
                    let strr = String(decoding: d, as: UTF8.self)
                    print(strr)
                } catch {
                    print(error)
                    return
                }
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            if self.method == REQUEST_METHODS.POST {
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            }
            if(token != nil && token != ""){
                urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            }
            var dataTask = URLSessionDataTask()
            
            dataTask = delegateFreeSession.dataTask(with: urlRequest) { data, response, errors in
                
                do {
                    let httpResponse=response as? HTTPURLResponse
                    //print(httpResponse!.statusCode ?? 0)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                        self.handleTokenExpiration { success in
                            
                            if success {
                                // Token yenilendikten sonra bu isteği tekrar çağır
                                self.processMain {response in
                                    callback(response)
                                }
                            } else {
                                res
                                    .setExceptionData("")
                                    .setResponseCode(httpResponse.statusCode)
                                callback(res.createResponse())
                            }
                        }
                    }
                    else{
                        var str = String(decoding: data!, as: UTF8.self)
                        print(str)
                        if(self.return_type == RETURN_TYPE.JSONOBJECT){
                            if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [String:AnyObject] {
                                let jo:NSDictionary = jsonOutput as NSDictionary
                                print(jo)
                                res.setJsonObject(jo)
                                    .setExceptionData("")
                                    .setResponseCode(httpResponse!.statusCode)
                                callback(res.createResponse())
                            }else{
                                res.setExceptionData("Hata")
                                    .setResponseCode(httpResponse!.statusCode)
                                callback(res.createResponse())
                            }
                        }else if(self.return_type == RETURN_TYPE.JSONARRAY){
                            if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                                let ja:[NSDictionary] = jsonOutput as [NSDictionary]
                                
                                res.setJsonArray(ja)
                                    .setExceptionData("")
                                    .setResponseCode(httpResponse!.statusCode)
                                callback(res.createResponse())
                            }else{
                                res.setExceptionData("Hata")
                                    .setResponseCode(httpResponse!.statusCode)
                                callback(res.createResponse())
                            }
                        }else if(self.return_type == RETURN_TYPE.STRING){
                            let str = String(decoding: data!, as: UTF8.self)
                            res.setJsonData(jsonData:str)
                                .setExceptionData("")
                                .setResponseCode(httpResponse!.statusCode)
                            callback(res.createResponse())
                            
                        }else if(self.return_type == RETURN_TYPE.DATA){
                            if let myData = data {
                                
                                res.setData(data!)
                                    .setExceptionData("")
                                    .setResponseCode(httpResponse!.statusCode)
                                callback(res.createResponse())
                            }else{
                                res.setExceptionData("Hata").setResponseCode(httpResponse!.statusCode)
                                callback(res.createResponse())
                            }
                        }
                    }
                } catch {
                    res.setExceptionData("Hata")
                    callback(res.createResponse())
                }
                
            }
            dataTask.resume()
            
        }
        else if(post_type==POST_TYPE.MULTIPART){
            let url: URL = URL(string: url_type)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            if(token != nil && token != ""){
                request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            }
            let boundary = UUID().uuidString
            let fieldName = "file"  // Sunucunun beklediği dosya parametre adı
            let fileName = postFile.lastPathComponent
            let mimeType = "image/jpeg"
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let random = true
            var body = Data()
            
            // --- Random Parametresi Ekleyelim ---
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"random\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(random)\r\n".data(using: .utf8)!) // "true" veya "false" olarak gönderir
            
            // --- Resim Dosyası Ekleyelim ---
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            
            // --- Görüntü verisini oku ve ekle ---
            if let imageData = try? Data(contentsOf: postFile) {
                body.append(imageData)
            }
            
            body.append("\r\n".data(using: .utf8)!)
            
            // --- Bitiş Sınır ---
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            // --- Yükleme işlemi ---
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    res.setExceptionData(error.localizedDescription)
                    callback(res.createResponse())
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    do {
                        if(self.return_type == RETURN_TYPE.JSONOBJECT){
                            if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [String:AnyObject] {
                                let jo:NSDictionary = jsonOutput as NSDictionary
                                print(jo)
                                res.setJsonObject(jo)
                                    .setExceptionData("")
                                    .setResponseCode(httpResponse.statusCode)
                                callback(res.createResponse())
                            }else{
                                res.setExceptionData("Hata")
                                    .setResponseCode(httpResponse.statusCode)
                                callback(res.createResponse())
                            }
                        }else if(self.return_type == RETURN_TYPE.JSONARRAY){
                            if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [[String:AnyObject]] {
                                let ja:[NSDictionary] = jsonOutput as [NSDictionary]
                                
                                res.setJsonArray(ja)
                                    .setExceptionData("")
                                callback(res.createResponse())
                            }else{
                                res.setExceptionData("Hata")
                                callback(res.createResponse())
                            }
                        }else if(self.return_type == RETURN_TYPE.STRING){
                            let str = String(decoding: data!, as: UTF8.self)
                            res.setJsonData(jsonData:str)
                                .setExceptionData("")
                            callback(res.createResponse())
                            
                        }
                    } catch {
                        res.setExceptionData("Hata")
                        callback(res.createResponse())
                    }
                }
            }
            
            task.resume()
        }
        
    }
    private var isRefreshing = false
    private var requestsToRetry: [(Result<Data, Error>) -> Void] = []
    
    private var accessToken: String = "initial_access_token"
    private let session = URLSession.shared
    private let lockQueue = DispatchQueue(label: "com.api.tokenlock")
    private let semaphore = DispatchSemaphore(value: 1)
    private func handleTokenExpiration(completion: @escaping (Bool) -> Void) {
        lockQueue.sync {
            guard !isRefreshing else {
                print("1")
                // Eğer zaten yenileme işlemi devam ediyorsa, istekleri sıraya al
                requestsToRetry.append { result in
                    switch result {
                    case .success:
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
                return
            }
            isRefreshing = true
        }
        guard let url = URL(string: Statics.host + URL_TYPE.refreshToken.description) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
           request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print("JSON Data: \(json)")
                    let newToken = json["token"] as? String
                    
                    self.token = newToken
                    CacheData.saveToken(data: self.token, duration: Statics.tokentimeMax)
                    
                    completion(true)
                    self.lockQueue.sync {
                        self.requestsToRetry.forEach { $0(.success(Data())) }
                        self.requestsToRetry.removeAll()
                    }
                }else{
                    completion(false)
                    
                    self.lockQueue.sync {
                        self.requestsToRetry.forEach { $0(.failure(NSError(domain: "Refresh failed", code: 401, userInfo: nil))) }
                        self.requestsToRetry.removeAll()
                    }
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        
    }
    func processRefresh(withBlock callback: @escaping OnComplete) {
        getServerResponseForUrlCallback = callback
        
        let res = responseBuilder()
        if(post_type != POST_TYPE.MULTIPART){
            let defaultConfigObject: URLSessionConfiguration = URLSessionConfiguration.default
            let delegateFreeSession: URLSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
            let url: URL = URL(string: url_type)!
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = self.method == REQUEST_METHODS.GET ? "GET" : "POST"
            print(self.method == REQUEST_METHODS.GET ? "GET" : "POST")
            if((self.method == REQUEST_METHODS.POST
                || self.method == nil) && jsonPostData != nil){
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonPostData, options: .prettyPrinted)
                    let d=try JSONSerialization.data(withJSONObject: jsonPostData, options: .prettyPrinted)
                    let strr = String(decoding: d, as: UTF8.self)
                    print(strr)
                } catch {
                    print(error)
                    return
                }
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            if self.method == REQUEST_METHODS.POST {
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            }
            if(token != nil && token != ""){
                urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            }
            var dataTask = URLSessionDataTask()
            
            dataTask = delegateFreeSession.dataTask(with: urlRequest) { data, response, errors in
                
                do {
                    let httpResponse=response as? HTTPURLResponse
                    print(httpResponse!.statusCode ?? 0)
                    
                    var str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    if(self.return_type == RETURN_TYPE.JSONOBJECT){
                        if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [String:AnyObject] {
                            let jo:NSDictionary = jsonOutput as NSDictionary
                            print(jo)
                            res.setJsonObject(jo)
                                .setExceptionData("")
                                .setResponseCode(httpResponse!.statusCode)
                            callback(res.createResponse())
                        }else{
                            res.setExceptionData("Hata")
                                .setResponseCode(httpResponse!.statusCode)
                            callback(res.createResponse())
                        }
                    }else if(self.return_type == RETURN_TYPE.JSONARRAY){
                        if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                            let ja:[NSDictionary] = jsonOutput as [NSDictionary]
                            
                            res.setJsonArray(ja)
                                .setExceptionData("")
                                .setResponseCode(httpResponse!.statusCode)
                            callback(res.createResponse())
                        }else{
                            res.setExceptionData("Hata")
                                .setResponseCode(httpResponse!.statusCode)
                            callback(res.createResponse())
                        }
                    }else if(self.return_type == RETURN_TYPE.STRING){
                        let str = String(decoding: data!, as: UTF8.self)
                        res.setJsonData(jsonData:str)
                            .setExceptionData("")
                            .setResponseCode(httpResponse!.statusCode)
                        callback(res.createResponse())
                        
                    }else if(self.return_type == RETURN_TYPE.DATA){
                        if let myData = data {
                            
                            res.setData(data!)
                                .setExceptionData("")
                                .setResponseCode(httpResponse!.statusCode)
                            callback(res.createResponse())
                        }else{
                            res.setExceptionData("Hata").setResponseCode(httpResponse!.statusCode)
                            callback(res.createResponse())
                        }
                    }
                } catch {
                    res.setExceptionData("Hata")
                    callback(res.createResponse())
                }
                
            }
            dataTask.resume()
            
        }
        else if(post_type==POST_TYPE.MULTIPART){
            let url: URL = URL(string: url_type)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            if(token != nil && token != ""){
                request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            }
            let boundary = UUID().uuidString
            let fieldName = "file"  // Sunucunun beklediği dosya parametre adı
            let fileName = postFile.lastPathComponent
            let mimeType = "image/jpeg"
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let random = true
            var body = Data()
            
            // --- Random Parametresi Ekleyelim ---
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"random\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(random)\r\n".data(using: .utf8)!) // "true" veya "false" olarak gönderir
            
            // --- Resim Dosyası Ekleyelim ---
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            
            // --- Görüntü verisini oku ve ekle ---
            if let imageData = try? Data(contentsOf: postFile) {
                body.append(imageData)
            }
            
            body.append("\r\n".data(using: .utf8)!)
            
            // --- Bitiş Sınır ---
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            // --- Yükleme işlemi ---
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    res.setExceptionData(error.localizedDescription)
                    callback(res.createResponse())
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    do {
                        if(self.return_type == RETURN_TYPE.JSONOBJECT){
                            if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [String:AnyObject] {
                                let jo:NSDictionary = jsonOutput as NSDictionary
                                print(jo)
                                res.setJsonObject(jo)
                                    .setExceptionData("")
                                    .setResponseCode(httpResponse.statusCode)
                                callback(res.createResponse())
                            }else{
                                res.setExceptionData("Hata")
                                    .setResponseCode(httpResponse.statusCode)
                                callback(res.createResponse())
                            }
                        }else if(self.return_type == RETURN_TYPE.JSONARRAY){
                            if let myData = data, let jsonOutput = try JSONSerialization.jsonObject(with: myData, options: []) as? [[String:AnyObject]] {
                                let ja:[NSDictionary] = jsonOutput as [NSDictionary]
                                
                                res.setJsonArray(ja)
                                    .setExceptionData("")
                                callback(res.createResponse())
                            }else{
                                res.setExceptionData("Hata")
                                callback(res.createResponse())
                            }
                        }else if(self.return_type == RETURN_TYPE.STRING){
                            let str = String(decoding: data!, as: UTF8.self)
                            res.setJsonData(jsonData:str)
                                .setExceptionData("")
                            callback(res.createResponse())
                            
                        }
                    } catch {
                        res.setExceptionData("Hata")
                        callback(res.createResponse())
                    }
                }
            }
            
            task.resume()
        }
        
    }
    public func process2(withBlock callback: @escaping OnComplete2) {
        getServerResponseForUrlCallback2 = callback
        for param in parameters as! [[String:Any]] {
            if param["disabled"] == nil {
                let paramType = param["type"] as! String
                if paramType == "text" {
                    
                } else {
                    let paramSrc = param["src"] as! String
                    do{
                        let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                        let fileContent = NSString(data: fileData, encoding: String.Encoding.utf8.rawValue)
                        let d:Data=fileContent!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
                        callback(d)
                    }catch{
                        
                        return
                    }
                }
            }
        }
    }
}


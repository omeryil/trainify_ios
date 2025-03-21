//
//  Functions.swift
//  trainig
//
//  Created by omer yildirim on 12.02.2025.
//

import Foundation
import UIKit

public class Functions {
    public typealias OnCompleteBool = (_ result:Bool?,_ error:String?)->Void
    public typealias OnCompleteWithData = (_ result:Any?,_ error:String?)->Void
    public typealias onAlertReturn = (_ result:Bool?)->Void
    public func login(data:Any ,onCompleteBool:@escaping OnCompleteBool) {
        LoginBuilder()
            .setHost(Statics.host)
            .setData(data).createLogin().process { response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    guard let json = response?.JsonObject as NSDictionary? else {
                        onCompleteBool(false,"Unexpected Error")
                        return
                    }
                    CacheData.saveToken(data: json.value(forKey: "token") as! String, duration: Statics.tokentimeMax)
                    
                    onCompleteBool(true,"")
                }else {
                   
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                    return
                }
            }
    }
    public func getRelationsOneContent(data:Any, listItem:String ,onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getRelations.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["results"] as! NSArray
                    let result = results[0] as! NSDictionary
                    let data=result["data"] as! NSArray
                    var content:NSDictionary? = nil
                    if data.count>0{
                        let itemRelation=data[0] as! NSDictionary
                        let related=itemRelation["related"] as! NSDictionary
                        let items=related[listItem] as! NSArray
                        let item=items[0] as! NSDictionary
                        content=item["content"] as? NSDictionary
                    }
                    onCompleteWithData(content,"")
                   
                    
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func getRelations(data:Any, listItem:String ,onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getRelations.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["results"] as! NSArray
                    let result = results[0] as! NSDictionary
                    let data=result["data"] as! NSArray
                    var items:NSArray=[]
                    if data.count>0{
                        let itemRelation=data[0] as! NSDictionary
                        let related=itemRelation["related"] as! NSDictionary
                        items=related[listItem] as! NSArray
                    }
                    onCompleteWithData(items,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func executeUserComment(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getUserComment.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["data"] as! NSArray
            
                    onCompleteWithData(results,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func executeUserUpcoming(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getUpcoming.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["data"] as! NSArray
            
                    onCompleteWithData(results,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func executeTrainerUpcoming(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getTrainerUpcoming.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["data"] as! NSArray
            
                    onCompleteWithData(results,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func executeUserBought(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getUserBought.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["data"] as! NSArray
            
                    onCompleteWithData(results,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func executeUserSolDates(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getUserSoldDates.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["data"] as! NSArray
            
                    onCompleteWithData(results,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func executeTrainerSold(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getTrainerSold.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["data"] as! NSArray
            
                    onCompleteWithData(results,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func getVideo(url:String, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost("")
            .setMethod(REQUEST_METHODS.GET)
            .setReturn_type(RETURN_TYPE.DATA)
            .setUrlType(url)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteWithData(response?.VData!,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func executeTrainerComment(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getTrainerComment.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let results=json["data"] as! NSArray
            
                    onCompleteWithData(results,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func update(data:Any,onCompleteBool:@escaping OnCompleteBool) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.updateCollection.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteBool(true,"")
                    
                }else {
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func delete(data:Any,onCompleteBool:@escaping OnCompleteBool) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.deleteCollection.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteBool(true,"")
                    
                }else {
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func addRelations(data:Any,onCompleteBool:@escaping OnCompleteBool) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.addRelation.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteBool(true,"")
                    
                }else {
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func addUniqueCollection(data:Any,onCompleteBool:@escaping OnCompleteBool) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.addUniqueCollection.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteBool(true,"")
                    
                }else {
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func addCollection(data:Any,onCompleteBool:@escaping OnCompleteBool) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.addCollection.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteBool(true,"")
                    
                }else {
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func addMultipleCollection(data:Any,onCompleteBool:@escaping OnCompleteBool) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.addMultiCollection.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteBool(true,"")
                    
                }else {
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func addCollection(data:Any,onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.addCollection.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteWithData(response?.JsonObject,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func getCollection(data:Any,onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getCollections.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let d=json["data"] as! NSArray
                    onCompleteWithData(d,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func search(start:String,text:String,onCompleteWithData:@escaping OnCompleteWithData) {
        let url:String = URL_TYPE.search.description+"/\(start)/\(text)"
        PostGetBuilder()
            .setHost(Statics.host)
            .setMethod(REQUEST_METHODS.GET)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONARRAY)
            .setUrlType(url)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonArray!
                    onCompleteWithData(json,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func getAdsFromSearcService(text:String,onCompleteWithData:@escaping OnCompleteWithData) {
        let url:String = URL_TYPE.getAdsFromSearchService.description+"/\(text)"
        PostGetBuilder()
            .setHost(Statics.host)
            .setMethod(REQUEST_METHODS.GET)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONARRAY)
            .setUrlType(url)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonArray!
                    onCompleteWithData(json,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func getFilters(onCompleteWithData:@escaping OnCompleteWithData) {
        
        PostGetBuilder()
            .setHost(Statics.host)
            .setMethod(REQUEST_METHODS.GET)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getFilters.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject!
                    onCompleteWithData(json,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func searchFilter(data:Any,start:String,text:String,onCompleteWithData:@escaping OnCompleteWithData) {
        let url:String = URL_TYPE.search.description+"/\(start)/\(text)"
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONARRAY)
            .setUrlType(url)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonArray!
                    onCompleteWithData(json,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func featured(data:Any,onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONARRAY)
            .setUrlType(URL_TYPE.getFeatured.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonArray!
                    onCompleteWithData(json,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func insertSearchData(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.DATA)
            .setUrlType(URL_TYPE.insertData.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteWithData(statusCode,"")
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    public func updateSearhPhoto(data:Any,onCompleteBool:@escaping OnCompleteBool) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.updateSearchService.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
               onCompleteBool(true,"")
            }
    }
    public func createMeetingToken(data:Any, onCompleteWithData:@escaping OnCompleteWithData) {
        PostGetBuilder()
            .setHost(Statics.host)
            .setJsonPostData(data)
            .setPost_type(POST_TYPE.JSON)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.createMeetingToken.description)
            .setToken(CacheData.getToken()!)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    let json = response?.JsonObject as! NSDictionary
                    let result=json["token"] as! String
            
                    onCompleteWithData(result,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    func getGuestToken(onCompleteBool:@escaping OnCompleteBool){
        let d = [] as Any
        LoginBuilder()
            .setHost(Statics.host).setData(d).createLogin().getGuestToken { response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    guard let json = response?.JsonObject as NSDictionary? else {
                        onCompleteBool(false,"Unexpected Error")
                        return
                    }
                    CacheData.saveToken(data: json.value(forKey: "token") as! String, duration: 3600)
                    
                    onCompleteBool(true,"")
                }else {
                    
                    onCompleteBool(false,self.returnError(response: response!, statusCode: statusCode ?? 500))
                    return
                }
            }
    }
    public func upload(data:URL, onCompleteWithData:@escaping OnCompleteWithData) {
        let params = [[
           "key": "file",
           "src": data,
           "type": "file"
         ],
         [
           "key": "random",
           "value": "true",
           "type": "text"
         ]] as [[String: Any]]
        PostGetBuilder()
            .setHost(Statics.host)
            .setPostFile(data)
            .setPost_type(POST_TYPE.MULTIPART)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.uploadFile.description)
            .setToken(CacheData.getToken()!)
            .setParameters(params)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    onCompleteWithData(response,"")
                    
                }else {
                    onCompleteWithData(nil,self.returnError(response: response!, statusCode: statusCode ?? 500))
                }
            }
    }
    
    func returnError(response:response,statusCode:Int) -> String {
        var err:String! = ""
        switch statusCode {
        case 401:
            err = "Unauthorized"
            break
        case 404:
            err = "Not Found"
            break
        case 500:
            err = "Internal Server Error"
            break
        case 503:
            err = "Service Unavailable"
            break
        case 777:
            err = PostGet.no_connection
            break
        case 406:
            err = "Not Acceptable"
            break
        default:
            err="Unexpected Error"
            break
        }
        return err
    }
    public func createAlert(self:UIViewController,title: String, message: String, yesNo: Bool,alertReturn:@escaping onAlertReturn) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "DarkBack")
        let attributedString = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        let attributedStringMessage = NSAttributedString(string: message, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        alert.setValue(attributedStringMessage, forKey: "attributedMessage")
        if yesNo {
            alert.addAction(UIAlertAction(title: String(localized: "cancel"), style: .default, handler: { (action: UIAlertAction!) in
                alertReturn(false)
              }))
        }
        alert.addAction(UIAlertAction(title: String(localized: "ok"), style: .default, handler: { (action: UIAlertAction!) in
            alertReturn(true)
          }))
        self.present(alert, animated: true, completion: {() -> Void in
            alert.view.tintColor = .white})

    }
    public static func createAlertStatic(self:UIViewController,title: String, message: String, yesNo: Bool,alertReturn:@escaping onAlertReturn) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "DarkBack")
        let attributedString = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        let attributedStringMessage = NSAttributedString(string: message, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        alert.setValue(attributedStringMessage, forKey: "attributedMessage")
        if yesNo {
            alert.addAction(UIAlertAction(title: String(localized: "cancel"), style: .default, handler: { (action: UIAlertAction!) in
                alertReturn(false)
              }))
        }
        alert.addAction(UIAlertAction(title: String(localized: "ok"), style: .default, handler: { (action: UIAlertAction!) in
            alertReturn(true)
          }))
        self.present(alert, animated: true, completion: {() -> Void in
            alert.view.tintColor = .white})

    }
}

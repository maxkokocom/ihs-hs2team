//
//  FriendsWorkoutAPI.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import Foundation
import Moya
import SwiftDate
import KeychainSwift
import Moya_Argo

class AuthenticationModel {
    
    func logout() {} /// TODO
    
    func token() -> String { return "" } /// TODO
    
    func setToken(token: String) {} /// TODO
}

enum KeychainKeys: String {
    
    case token
    case email
    case password
}

//-- Endpoints ----------------------------------------

private var authenticationModel = AuthenticationModel()

enum FriendsWorkoutAPI {
    
    /// Not used
    case Me()
    
    case PostSession( encodedSession: Data )
    
    case Forget( email: String )
    
    case Login( email: String, password: String )
    
    case Register( email: String, password: String )
}

let endpointClosure = { (target: FriendsWorkoutAPI) -> Endpoint<FriendsWorkoutAPI> in
    
    let url = URL(target: target).absoluteString
    
    return Endpoint<FriendsWorkoutAPI>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
}

private var defaultError: Moya.MoyaError = {
    
    Moya.MoyaError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil), nil)
}()

private func canRefreshAccessToken() -> Bool {
    
    return (KeychainSwift().get(KeychainKeys.email.rawValue) != nil) && (KeychainSwift().get(KeychainKeys.password.rawValue) != nil)
}

func defaultRequest( aidlab: FriendsWorkoutAPI, progress: ProgressBlock?, completion: @escaping Completion ) -> Cancellable {
    
    //let defaultFriendsWorkoutAPIProvider = MoyaProvider<FriendsWorkoutAPI>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: nil)])
    let defaultFriendsWorkoutAPIProvider = MoyaProvider<FriendsWorkoutAPI>(endpointClosure: endpointClosure, plugins: [])
    
    return defaultFriendsWorkoutAPIProvider.request(aidlab, callbackQueue: DispatchQueue.main, progress: progress, completion: { result in
        
        if case let .success(response) = result {
            
            /// User has sent inccorect credentials or token is dead
            if response.statusCode == 401 {
                
                /// Try to refresh access token if possible
                if canRefreshAccessToken() {
                    _ = refreshAccessToken( completion: { success in
                        
                        if success {
                            _ = defaultRequest(aidlab: aidlab, progress: progress, completion: completion)
                        } else {
                            AuthenticationModel().logout()
                        }
                    })
                }
                    /// If I am unable to refresh token and I've got 401, then I
                    /// should be logged out
                else {
                    AuthenticationModel().logout()
                    completion( result )
                }
                
            } else {
                completion( result )
            }
            
        } else if case let .failure(error) = result {
            
            print(error)
            completion( result )
            
            if error._code == NSURLErrorCannotFindHost {
                presentToast("Could not connect to remote")
            }
        }
    })
}

func refreshAccessToken( completion: @escaping ((_ success: Bool) -> Void) ) {
    
    guard let email = KeychainSwift().get(KeychainKeys.email.rawValue),
        let password = KeychainSwift().get(KeychainKeys.password.rawValue) else {
            
            assert(false, "Shouldn't be here")
            return
    }
    
    KeychainSwift().delete(KeychainKeys.email.rawValue)
    KeychainSwift().delete(KeychainKeys.password.rawValue)
    
    _ = defaultRequest(aidlab: .Login(email: email, password: password), completion: { result in
        
        if case let .success(response) = result {
            
            if 200 ... 299 ~= response.statusCode {
                do {
                    KeychainSwift().set(email, forKey: KeychainKeys.email.rawValue)
                    KeychainSwift().set(password, forKey: KeychainKeys.password.rawValue)
                    
                    let authentication: Authentication = try response.mapObject()
                    
                    AuthenticationModel().setToken(token: authentication.token)
                    
                    completion(true)
                    return
                    
                } catch let error {
                    
                    print("Mapping error: \(error)")
                }
            } else {
                print("Failure on refreshing access token...")
            }
            
        } else if case let .failure(error) = result {
            
            print(error)
        }
        
        completion(false)
    })
}

func defaultRequest( aidlab: FriendsWorkoutAPI, completion: @escaping Completion ) -> Cancellable {
    
    return defaultRequest( aidlab: aidlab, progress: nil, completion: completion )
}

extension FriendsWorkoutAPI: TargetType {
    
    /// Note: If we'll be using more than one API base URL,
    /// separate them out into separate enums and Moya providers
    var baseURL: URL { return URL(string: Config.FriendsWorkoutAPIBaseURL)! }
    
    var path: String {
        
        switch self {
            
        case .Me:
            return "/users/me"
        case .PostSession:
            return "/sessions"
        case .Forget:
            return "/forget"
        case .Login:
            return "/login"
        case .Register:
            return "/register"
        }
    }
    
    var headers: [String: String]? {
        
        switch self {
            
        case .Login, .Register:
            return [:]
        default:
            return ["Authorization": "Bearer " + (authenticationModel.token() ?? "")]
        }
    }
    
    var method: Moya.Method {
        
        switch self {
            
        case .Me:
            return .get
        case .PostSession:
            return .post
        case .Forget:
            return .post
        case .Login:
            return .post
        case .Register:
            return .post
        }
    }
    
    var sampleData: Data {
        
        switch self {
            
        default:
            return Data()
        }
    }
    
    /// Be aware, this might be invoked more than once for one request, due to
    /// Moya's integral logic. So logs or time-consuming operations might not
    /// have sense here
    var task: Task {
        
        switch self {
            
        case .Me:
            return .requestPlain
       case .Forget(let email):
            return .requestParameters(parameters:["email": email], encoding: JSONEncoding.default)
        case .Login(let email, let password):
            return .requestParameters(parameters:["email": email, "password": password], encoding: JSONEncoding.default)
        case .Register(let email, let password):
            return .requestParameters(parameters:["email": email, "password": password], encoding: JSONEncoding.default)
        case .PostSession( let session ):
            let data: [MultipartFormData] = [MultipartFormData(provider: .data(session), name: "", fileName: "session.json", mimeType: "application/json")]
            return .uploadMultipart(data)
        }
    }
}

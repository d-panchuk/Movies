//
//  NetworkManager.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation
import RxSwift

struct NetworkManager {
    
    private let dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }
    
    func execute<ResponseType: Codable>(
        request: RequestType,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
    ) -> URLSessionTask? {

        return dispatcher.dispatch(
            requestData: request.data,
            onSuccess: { data in
                do {
                    let result = try JSONDecoder().decode(ResponseType.self, from: data)
                    onSuccess(result)
                } catch let error {
                    onError(error)
                }
            },
            onError: { (error: Error) in
                onError(error)
            }
        )
    }
    
    func execute<ResponseType: Codable>(request: RequestType) -> Single<ResponseType> {
        return Single<ResponseType>.create { single in
            let task = self.execute(
                request: request,
                onSuccess: { response in
                    single(.success(response))
                },
                onError: { error in
                    single(.error(error))
                }
            )
            return Disposables.create { task?.cancel() }
        }
    }
    
}

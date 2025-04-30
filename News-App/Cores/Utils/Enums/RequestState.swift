//
//  RequestState.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

enum RequestState {
    case loading
    case loaded
    case error(_: ResponseError)
}

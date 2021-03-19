//
//  Remotable.swift
//  SupportFiles
//
//  Created by Marlo Kessler on 24.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import Foundation

public protocol Remotable {
    associatedtype RemoteConfigurationKeys
    
    static func getDefaultRemoteValues() -> [String: Any?]
}

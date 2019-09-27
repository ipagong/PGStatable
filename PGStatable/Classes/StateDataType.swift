//
//  StateDataType.swift
//
//  Created by ipagong on 09/07/2019.
//  Copyright © 2019 suwan.park All rights reserved.
//

import Foundation

public protocol StateDataType {
    var key:String? { get }
}

extension StateDataType {
    var key:String? { return nil }
}

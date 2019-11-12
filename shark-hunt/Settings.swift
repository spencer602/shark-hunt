//
//  Settings.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/11/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

struct Settings {
    static var isLocal = false
    
    static var urlStringPrefix: String {
        return Settings.isLocal ? "http://localhost:8888/league-manager/" : "http://www.bigskysharkhunt.com/"
    }
}

//
//  FileManager-DocumentsDirectory.swift
//  Bucketlist
//
//  Created by user215924 on 5/1/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

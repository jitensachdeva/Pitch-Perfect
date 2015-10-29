//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jitendra Sachdeva on 28/09/15.
//  Copyright (c) 2015 Dijini. All rights reserved.
//

import Foundation

class RecordedAudio{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String! ){
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}

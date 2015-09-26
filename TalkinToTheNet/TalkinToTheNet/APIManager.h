//
//  APIManager.h
//  learnAPI
//
//  Created by Diana Elezaj on 9/20/15.
//  Copyright © 2015 Diana Elezaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+(void) GETRequestWithURL:(NSURL *)URL
        completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))
        completionBlock;

@end

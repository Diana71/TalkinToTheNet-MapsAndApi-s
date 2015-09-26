//
//  InstaPost.m
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/26/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "InstaPost.h"


@implementation InstaPost
-(instancetype)initWithJSON: (NSDictionary *)json{
    
    //call super init, return self
    
    if (self = [super init]){
        
        self.tags = [json objectForKey:@"tags"];
        self.commentCount = [json[@"comments"][@"count"]integerValue];
        self.likeCount = [json[@"likes"][@"count"]integerValue];
        
        self.username = json[@"user"][@"username"];
        self.fullName = json[@"user"][@"full_name"];
        self.caption = json[@"caption"];
        
        NSString *imageURLString = json[@"images"][@"low_resolution"][@"url"];
        
        NSURL *url = [NSURL URLWithString:imageURLString];
        
        NSData  *imageData = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:imageData];

        
        
        
        
        
//        UIImage *image = [self createImageFromString:imageURLString];
        self.instaImage = image;
        
        return self;
        
    }
    
    return nil;
    
}
@end

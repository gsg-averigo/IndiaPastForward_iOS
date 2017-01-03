//
//  Article.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "Article.h"

@implementation Article

+ (Article *)objectFromDictionary:(NSDictionary *)dictionary
{
    Article *article = [[Article alloc] init];
    for (NSString *key in dictionary.allKeys) {
        if([key isEqualToString:@"posted_title"]){
            article.title = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"posted_link"]){
            article.url = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"MediaFileType"]){
            if([[dictionary objectForKey:key] isEqualToString:@"W"]){
                article.mediaFileType = W;
            }
            else{
                NSLog(@"%@",[dictionary objectForKey:key]);
            }
        }
    }
    return article;
}

@end

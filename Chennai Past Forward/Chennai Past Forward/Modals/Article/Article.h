//
//  Article.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MediaFileType{
    W
}MediaFileType;

@interface Article : NSObject
@property (nonatomic) MediaFileType mediaFileType;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
+ (Article *)objectFromDictionary:(NSDictionary *)dictionary;
@end

//
//  XMLReader.h
//  Utilities
//
//  Created by Harish Kishenchand on 15/11/12.
//  Copyright (c) 2012 Surana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *dictionaryStack;
@property (strong, nonatomic) NSMutableString *textInProgress;
@property (strong, nonatomic) NSError *error;

- (NSDictionary *)objectWithData:(NSData *)data;
- (NSDictionary *)objectWithString:(NSString *)string;

//+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)error;
//+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)error;

@end

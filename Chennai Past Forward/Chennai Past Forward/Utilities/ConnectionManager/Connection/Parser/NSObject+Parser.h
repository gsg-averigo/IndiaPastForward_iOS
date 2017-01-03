//
//  NSObject+Parser.h
//  ConnectionManager
//
//  Created by Harish Kishenchand on 11/05/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Parser)
- (id)jsonValue;
- (id)xmlValue;
@end


@interface NSData (Parser)
- (id)jsonValue;
- (id)xmlValue;
@end


@interface NSDictionary (Parser)
- (NSString *)jsonRepresentation;
@end


@interface NSArray (Parser)
- (NSString *)jsonRepresentation;
@end


@interface NSObject (Parser)
- (NSString *)jsonRepresentation;
@end
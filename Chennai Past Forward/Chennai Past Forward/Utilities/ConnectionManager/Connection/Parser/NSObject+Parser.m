//
//  NSObject+Parser.m
//  ConnectionManager
//
//  Created by Harish Kishenchand on 11/05/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "NSObject+Parser.h"

#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "XMLReader.h"

@implementation NSString (Parser)

- (id)jsonValue{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id repr = [parser objectWithString:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error is: %@", parser.error);
    return repr;
}

- (id)xmlValue{
    return [[[XMLReader alloc] init] objectWithString:self];
}

@end


@implementation NSData (Parser)

- (id)jsonValue{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id repr = [parser objectWithData:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error is: %@", parser.error);
    return repr;
}

- (id)xmlValue{
    return [[[XMLReader alloc] init] objectWithData:self];
}

@end


@implementation NSObject (Parser)

- (NSString *)jsonRepresentation{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *json = [writer stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error is: %@", writer.error);
    return json;
}

@end


/*@implementation NSString (Parser)

- (id)jsonValue{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id repr = [parser objectWithString:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error is: %@", parser.error);
    return repr;
}

- (id)xmlValue{
    return [[[XMLReader alloc] init] objectWithString:self];
}

@end


@implementation NSData (Parser)

- (id)jsonValue{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id repr = [parser objectWithData:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error is: %@", parser.error);
    return repr;
}

- (id)xmlValue{
    return [[[XMLReader alloc] init] objectWithData:self];
}

@end


@implementation NSDictionary (Parser)
- (NSString *)jsonRepresentation{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *json = [writer stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error is: %@", writer.error);
    return json;
}
@end


@implementation NSArray (Parser)
- (NSString *)jsonRepresentation{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *json = [writer stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error is: %@", writer.error);
    return json;
}
@end


@implementation NSObject (Parser)
- (NSString *)jsonRepresentation{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *json = [writer stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error is: %@", writer.error);
    return json;
}

@end*/


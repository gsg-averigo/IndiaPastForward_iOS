//
//  Message.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 27/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>
/*typedef enum MESSAGE_TYPE{
    MESSAGE_TYPE_O,
    MESSAGE_TYPE_N
}MESSAGE_TYPE;*/

@interface Message : NSObject
//@property (nonatomic) MESSAGE_TYPE message_type;
@property (strong,nonatomic) NSString *messageType;
@property (strong, nonatomic) NSString *messageGUID;
@property (strong, nonatomic) NSString *messageBy;
@property (strong, nonatomic) NSString *messageTitle;
@property (strong, nonatomic) NSString *messageDescription;
@property (strong, nonatomic) NSString *enablewalk;
@property (strong, nonatomic) NSString *titles;

@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *validFrom;
@property (strong, nonatomic) NSDate *validUpto;
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSString *audioFile;
@property (strong, nonatomic) NSString *videoFile;
@property (strong, nonatomic) NSString *photoString;
+ (Message *)objectFromDictionary:(NSDictionary *)dictionary;
@end

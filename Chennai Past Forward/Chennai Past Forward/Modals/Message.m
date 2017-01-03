//
//  Message.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 27/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "Message.h"

@implementation Message
- (id)init{
    self = [super init];
    if(self){
        //self.message_type = MESSAGE_TYPE_O;
    }
    return self;
}

+ (Message *)objectFromDictionary:(NSDictionary *)dictionary
{
    Message *message = [[Message alloc] init];
   
    
    NSLog(@"Dic %@", dictionary);
    
    for (NSString *key in dictionary.allKeys) {
       /* if([key isEqualToString:@"MessageType"]){
            if ([[dictionary objectForKey:key] isEqualToString:@"O"]) {
                //message.message_type = MESSAGE_TYPE_O;
            }
            else if ([[dictionary objectForKey:key] isEqualToString:@"N"]) {
                //message.message_type = MESSAGE_TYPE_N;
            }
        }
        
      else */
        if([key isEqualToString:@"MessageType"])
        {
                message.messageType = [dictionary objectForKey:key];
            
            NSLog(@"the message TYPE %@", message.messageType);
        }
        else if([key isEqualToString:@"GUID"] || [key isEqualToString:@"AdminNotificationGUID"]){
            message.messageGUID = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"MessageBy"]){
            message.messageBy = [dictionary objectForKey:key];
            
                    }
        else if([key isEqualToString:@"Title"] || [key isEqualToString:@"NotificationTitle"]){
        
            
            message.messageTitle = [dictionary objectForKey:key];
            
            
           
        }
        
        
        
        
        
        
        else if([key isEqualToString:@"Description"]){
            message.messageDescription = [dictionary objectForKey:key];
            message.messageDescription = [message.messageDescription stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            message.messageDescription = [message.messageDescription stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
            message.messageDescription = [message.messageDescription stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            message.messageDescription = [message.messageDescription stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            message.messageDescription = [message.messageDescription stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        }
        
        else if ([key isEqualToString:@"CreatedDateTime"]){
            message.date = [NSDate dateFromString:[dictionary objectForKey:key]];

            
        }
        
        else if([key isEqualToString:@"AudioFile"]){
            message.audioFile = [dictionary objectForKey:key];
            NSLog(@"the jjdjd %@", message.audioFile);
        }
        
        else if([key isEqualToString:@"VideoFile"]){
            message.videoFile = [dictionary objectForKey:key];
        }
       
        
        
        else if([key isEqualToString:@"EnableWalk"]){
            message.enablewalk = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"ValidFrom"]){
            message.validFrom = [NSDate dateFromString:[dictionary objectForKey:key]];
        }
        else if([key isEqualToString:@"ValidTo"]){
            message.validUpto = [NSDate dateFromString:[dictionary objectForKey:key]];
        }
        else if([key isEqualToString:@"Photo"]){
            message.photoString = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"CreatedDateTime"]){
            message.createdDate = [NSDate dateFromString:[dictionary objectForKey:key]];
        }
    }
    return message;
}
@end

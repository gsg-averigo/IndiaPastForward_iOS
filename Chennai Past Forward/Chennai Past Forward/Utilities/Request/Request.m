//
//  Request.m
//  cpf
//
//  Created by Harish Kishenchand on 24/09/13.
//  Copyright (c) 2013 geval6. All rights reserved.
//

#import "Request.h"

#import "UIDevice+IdentifierAddition.h"

@implementation Request

+ (void)makeRequestWithIdentifier:(ConnectionIdentifier)identifier parameters:(NSDictionary *)parameters delegate:(id)delegate
{
    NSString *urlString = [ROOT_URL stringByAppendingFormat:@"services/%@.php?%@",[Request actionForIdentifier:identifier],[Request parameterString:parameters]];
    NSLog(@"parameters%@",parameters);
    NSLog(@"the value siuidn%@", urlString);
    Connection *connection = [[Connection alloc] initWithUrl:[NSURL URLWithString:urlString]];
    [connection setConnectionDelegate:(id<ConnectionDelegate>)delegate];
    [connection setConnectionIdentifier:identifier];
    [connection setIsModalConnection:YES];
    [[ConnectionManager defaultManager] addConnection:connection];
}


+ (NSString *)UDID
{
    [[UIDevice currentDevice] uniqueDeviceIdentifier];
     return [[NSUUID UUID] UUIDString];
}

+ (NSString *)actionForIdentifier:(ConnectionIdentifier)identifier{
    switch (identifier)
    {
        case SEND_ACCESS_CODE:
            return @"get_sendaccesscode";
        case CHECK_ALREADY_REGISTERED:
            return @"get_checkalreadyregistred";
        case REGISTER_USER:
            return @"get_registeruser";
        case UPDATE_GCMID:
            return @"get_updategcmid";
        case SEARCH_HERITAGE:
            return @"heritagebuilding_lng_V2";
        case SEARCH_PUSH:
            return @"get_searchbyheritagepush";
        case SEARCH_ARTICLE:
            return @"get_searchbyarticle";
        case SEARCH_LATLONG:
            return @"get_searchbylatitudelongitude_V2";
        case RELATED_ARTICLE:
            return @"get_relatedarticle";
        case MESSAGEBOX_INFO:
            return @"get_messageboxinfo";
        case COUNT_BY_LOCATION:
            return @"get_hbcountbylatitudelongitude";
        case REGISTER_WALK:
            return @"get_regtowalk";
        case HERITAGE_WALK:
            return @"get_heritagewalk";
        case SEND_CODE:
            return @"get_sendbankcode";
        case AUDIO_DATA:
            return @"";
        case VIDEO_DATA:
            return @"";
        case TWEETS_DATA:
            return @"get_tweets_V3";
        case GET_LANG:
            return @"send_language_V2";
        case GET_CAMERA:
            return @"get_searchbylatitudelongitudeCamera";
        case NEARBY_SEARCH:
            return @"nearbysearch";
        case ENQUIRY:
            return @"upload_enquiry_images";
        case INDIA_HERITAGE:
            return @"get_ind_searchbylatlng";
    }
    return @"";
}

+ (NSString *)parameterString:(NSDictionary *)parameters
{
    NSString *returnString = @"";
    for (NSString *key in parameters.allKeys)
    {
        returnString = [returnString stringByAppendingString:(returnString.length == 0) ? @"": @"&"];
        returnString = [returnString stringByAppendingFormat:@"%@=%@",key, [parameters objectForKey:key]];
    }
    return [returnString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
 
@end

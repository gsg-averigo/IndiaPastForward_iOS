//
//  MyButton.h
//  Chennai Past Forward
//
//  Created by BTS on 15/09/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyButton :UIButton
{
 CLLocationCoordinate2D _Coordinates;
}
@property (nonatomic, assign) CLLocationCoordinate2D Coordinates;

@end

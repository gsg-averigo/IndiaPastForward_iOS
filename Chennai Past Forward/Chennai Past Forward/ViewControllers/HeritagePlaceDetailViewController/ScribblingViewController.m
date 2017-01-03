//
//  ScribblingViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 14/01/16.
//  Copyright (c) 2016 Harish. All rights reserved.
//

#import "ScribblingViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface ScribblingViewController ()

@end

@implementation ScribblingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (IPAD)
    {
        self = [super initWithNibName:@"ScribblingViewController~ipad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"ScribblingViewController" bundle:nil];
    }
    
    if(self){
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.rootViewController.self.topvew.hidden = NO;
    if(IPAD){
        scrachView.frame = CGRectMake(20, 180, 500, 350);
        _colorView.frame = CGRectMake(scrachView.frame.origin.x,scrachView.frame.origin.y+ scrachView.frame.size.height+20, scrachView.size.width, 150);
        
    }
    
    else
    {
        scrachView.frame = CGRectMake(20, 140, 280, 250);
//        _colorView.frame = CGRectMake(scrachView.frame.origin.x, , scrachView.size.width, 100);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];
}

#pragma mark - Screen Rotations



- (IBAction)previewAction:(id)sender
{
    CGRect rect = [[UIScreen mainScreen] bounds];

    
   
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [scrachView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    
    
    PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
    [detailViewController setRootViewController:self.rootViewController];
    
    _scrachData1 = UIImagePNGRepresentation(image);
    
    detailViewController.imgUrl = _urlString;
    detailViewController.name = _name ;
    detailViewController.desc =[self stringByStrippingHTML];
    detailViewController.data1 = _scrachData1;
     detailViewController.heritagePlaces=self.heritagePlaces;
    [detailViewController.view setSize:self.view.frame.size];
    [self.rootViewController pushViewController:detailViewController animated:YES];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)penAction:(id)sender
{
   drawingView.drawTool = ACEDrawingToolTypePen;

}

- (IBAction)setColor:(id)sender
{
    UIButton* button = (UIButton*)sender;
    scrachView.drawColor = button.backgroundColor;
    
}



- (IBAction)eraserAction:(id)sender
{
    drawingView.drawTool = ACEDrawingToolTypeEraser;
}

-(NSString *) stringByStrippingHTML
{
    NSRange r;
    //    _desc = [self copy];
    while ((r = [_desc rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        _desc = [_desc stringByReplacingCharactersInRange:r withString:@""];
    NSLog(@"%@",_desc);
    return _desc;
}

#pragma mark - Delete
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    _lastPoint = [touch locationInView:self.tempImageView];
    
    if (_isErasing) {
        self.tempImageView.image = self.drawImageView.image;
        self.drawImageView.image = nil;
    }
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.tempImageView];
    
    UIGraphicsBeginImageContext(self.tempImageView.frame.size);
    [self.tempImageView.image drawInRect:CGRectMake(0, 0, self.tempImageView.frame.size.width, self.tempImageView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _width );
    
    
    if (_isErasing) {
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    }
    else {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), _red, _green, _blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempImageView setAlpha:_alpha];
    UIGraphicsEndImageContext();
    
    _lastPoint = currentPoint;
}





- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGSize size = self.tempImageView.frame.size;
    
    if(!_mouseSwiped) {
        UIGraphicsBeginImageContext(self.tempImageView.frame.size);
        [self.tempImageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _width);
        
        
        if (_isErasing) {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        }
        else {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), _red, _green, _blue, _alpha);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        }
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    
    
    UIGraphicsBeginImageContext(self.drawImageView.frame.size);
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempImageView.image drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeNormal alpha:_alpha];
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempImageView.image = nil;
    UIGraphicsEndImageContext();
}*/
@end

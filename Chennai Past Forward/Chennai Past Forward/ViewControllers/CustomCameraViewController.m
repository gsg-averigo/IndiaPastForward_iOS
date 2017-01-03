//
//  CustomCameraViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 29/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import "CustomCameraViewController.h"
#import "EnquirySubmitViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface CustomCameraViewController ()



@end

@implementation CustomCameraViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   //if(~iPad)
    //self = [super initWithNibName:@"CustomCameraViewController" bundle:nil];
    if (IPAD)
    {
        self = [super initWithNibName:@"CustomCameraViewController~iPad" bundle:nil];
    }
   else {
        self = [super initWithNibName:@"CustomCameraViewController" bundle:nil];
       //self=[super initWithNibName:@"CustomView" bundle:nil];
       //self=[super initWithNibName:@"EnquiryPhotoViewController" bundle:nil];
    }

    if(self){
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.camera_view setHidden:NO];
    [self.camera_img setHidden:YES];
    _numberOfViews=3;
    _image_array=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(doTheReload:)
                                          name:@"IMAGE_ARRAY"
                                          object:nil];
    UIView *custom =[[UIView alloc] initWithFrame:CGRectMake(50, 0,100,50)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 40, 50)];
    label1.text = @"title";
    [custom addSubview:label1];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(45,0, 40, 50)];
    [button setTitle:@"info" forState:UIControlStateNormal];
    [custom addSubview:button];
    _image_array=[[NSMutableArray alloc]init];
    [self.image_scroll setAlwaysBounceVertical:NO];
    self.image_scroll.contentSize = CGSizeMake(self.view.frame.size.width,80);
    self.segment_ctrl.selectedSegmentIndex=0;
    [self.segment_ctrl sendActionsForControlEvents:UIControlEventValueChanged];
    
    CGFloat XOrigin = 0;
    _add =[[UIButton alloc] initWithFrame:CGRectMake(XOrigin,20,40,40)];
    [_add setImage:[UIImage imageNamed:@"PlusFilledNew-64.png"] forState:UIControlStateNormal];
    [_add addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
    [_add setUserInteractionEnabled:YES];
    [_add setTag:1];
    [self.image_scroll addSubview:_add];
    [_add setHidden:YES];
    
}
-(void)doTheReload:(NSNotification *) notification
{
    NSLog(@"NSNOTIFICATIONCENTER%@",notification);
    _image_array= [[notification userInfo] objectForKey:@"myImageArray"];
    for (UIImageView *v in self.image_scroll.subviews) {
        [v removeFromSuperview];
    }
    [self AddImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didCaptureImage:(UIImage *)image {
    //Use the image that is received
    _chosen_image = image;
    //self.camera_img.image = _chosen_image;
    if(_image_array.count<_numberOfViews)
    {
        [_image_array addObject:_chosen_image];
        int tag=_image_array.count;
        int i=_image_array.count-1;
        NSLog(@"IMAGE ARRAY count %lu",(unsigned long)i);
        CGFloat xOrigin = i * 90;
        UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,80,80)];
        dot.image=_chosen_image;
        dot.userInteractionEnabled=YES;
        [dot setTag:tag];
        UIButton * ButtonOnImageView = [[UIButton alloc]init];
        [ButtonOnImageView setFrame:CGRectMake(60,0,20,20)];
        [ButtonOnImageView setTag:tag];
        [ButtonOnImageView setImage:[UIImage imageNamed:@"Delete-32.png"] forState:UIControlStateNormal];
        [ButtonOnImageView addTarget:self action:@selector(OnClickOfTheButton:) forControlEvents:UIControlEventTouchUpInside];
        [dot addSubview:ButtonOnImageView];
        [ButtonOnImageView setUserInteractionEnabled:YES];
        [self.image_scroll addSubview:dot];
        NSLog(@"subview size %ld",(unsigned long)[[self.image_scroll subviews]count]);
        NSLog(@"content size width %lu",(unsigned long)self.image_scroll.frame.size.width);
        NSLog(@"segment selected %d",i);
        if((i+1)<_numberOfViews)
        {
            CGFloat XOrigin = (i+1)*90;
            UIButton *add =[[UIButton alloc] initWithFrame:CGRectMake(XOrigin,20,40,40)];
            [add setImage:[UIImage imageNamed:@"PlusFilledNew-64.png"] forState:UIControlStateNormal];
            [add addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
            [add setUserInteractionEnabled:YES];
            [add setTag:i+1];
            [self.image_scroll addSubview:add];
        }
    }
    else{
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"IndiaPastForward"
                                                              message:@"Can't pick more than three images"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
        
    }

}
-(void)didCaptureImageWithData:(NSData *)imageData {
    //Use the image's data that is received
}
-(IBAction)segment_selected:(id)sender
{
    NSLog(@"SEGMENT CLICKECD");
    if(self.segment_ctrl.selectedSegmentIndex==0){
        [_add removeFromSuperview];
        NSLog(@"camera selected");
        NSLog(@"rootviewcontroller %@",self.rootViewController);
        [self.camera_view setHidden:NO];
        [self.camera_img setHidden:YES];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else
        {
            NSLog(@"frame width %f",self.view.frame.size.width);
            NSLog(@"frame height %f",self.view.frame.size.height);
            NSLog(@"frame width %f",self.cameraView.frame.size.width);
            NSLog(@"frame height %f",self.cameraView.frame.size.height);
           self.cameraView=[[CameraSessionView alloc]initWithFrame:CGRectMake(0, 0,self.camera_view.frame.size.width,self.camera_view.frame.size.height)];
//            
//            if(IPAD)
//            {
//                self.cameraView=[[CameraSessionView alloc]initWithFrame:CGRectMake(0, 0,768,600)];
//            }
//            else
//            {
//                self.cameraView=[[CameraSessionView alloc]initWithFrame:CGRectMake(0, 0,320,148)];
//            }
            [self.cameraView setTopBarColor:[UIColor blackColor]];
            self.cameraView.delegate = self;
            [self.cameraView hideCameraToggleButton];
            [self.cameraView hideDismissButton];
            [self.camera_view addSubview:self.cameraView];
            
        }
        
        
    }
    else if(self.segment_ctrl.selectedSegmentIndex==1){
        NSLog(@"gallery selected");
        [self.camera_view setHidden:YES];
        [self.camera_img setHidden:NO];
        [_add setHidden:NO];
        if(_image_array.count<_numberOfViews)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.rootViewController presentViewController:picker animated:YES completion:nil];
        }
        else{
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Past Forward"
                                                                  message:@"Can't pick more than three images"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //[_cameraView removeFromSuperview];
    _chosen_image = info[UIImagePickerControllerOriginalImage];
    self.camera_img.image = _chosen_image;    
    if(_image_array.count<_numberOfViews)
    {
        [_image_array addObject:_chosen_image];
        [picker dismissViewControllerAnimated:YES completion:nil];
        int tag=_image_array.count;
        int i=_image_array.count-1;
        NSLog(@"IMAGE ARRAY count %lu",(unsigned long)i);
        CGFloat xOrigin = i * 90;
        UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,80,80)];
        dot.image=_chosen_image;
        dot.userInteractionEnabled=YES;
        [dot setTag:tag];
        UIButton * ButtonOnImageView = [[UIButton alloc]init];
        [ButtonOnImageView setFrame:CGRectMake(60,0,20,20)];
        [ButtonOnImageView setTag:tag];
        [ButtonOnImageView setImage:[UIImage imageNamed:@"Delete-32.png"] forState:UIControlStateNormal];
        [ButtonOnImageView addTarget:self action:@selector(OnClickOfTheButton:) forControlEvents:UIControlEventTouchUpInside];
        [dot addSubview:ButtonOnImageView];
        [ButtonOnImageView setUserInteractionEnabled:YES];
        [self.image_scroll addSubview:dot];
        NSLog(@"subview size %ld",(unsigned long)[[self.image_scroll subviews]count]);
        NSLog(@"content size width %lu",(unsigned long)self.image_scroll.frame.size.width);
        NSLog(@"segment selected %d",i);
        if((i+1)<_numberOfViews)
        {
            CGFloat XOrigin = (i+1)*90;
            _add =[[UIButton alloc] initWithFrame:CGRectMake(XOrigin,20,40,40)];
            [_add setImage:[UIImage imageNamed:@"PlusFilledNew-64.png"] forState:UIControlStateNormal];
            [_add addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
            [_add setUserInteractionEnabled:YES];
            [_add setTag:i+1];
            [self.image_scroll addSubview:_add];
        }
        //        if(self.segmentcontrol.selectedSegmentIndex==1&&i!=2)
        //        {
        //            [self performSelector:@selector(opengallery) withObject:self afterDelay:1.0 ];
        //        }
        
    }
    else{
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Past Forward"
                                                              message:@"Can't pick more than three images"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
        
    }
    
    
}
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)opengallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
    
}

-(IBAction)OnClickOfTheButton:(UIButton *)button
{
    
    NSLog(@"IMAGE ARRAY SIZE %lu",(unsigned long)_image_array.count);
    UIImageView *subview =[self.image_scroll viewWithTag:button.tag];
    [_image_array removeObject:[subview image]];
    for (UIImageView *v in self.image_scroll.subviews) {
        [v removeFromSuperview];
    }
    NSLog(@"delete array count %lu",(unsigned long)_image_array.count);
    [self AddImage];
    
}
-(void)AddImage
{
    if(_image_array.count!=0)
    {
        for (int i=0; i<=_image_array.count;i++) {
            if(i<_image_array.count)
            {
                NSLog(@"i in if %d",i);
                CGFloat xOrigin = i * 90;
                UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,80,80)];
                dot.image=[_image_array objectAtIndex:i];
                dot.userInteractionEnabled=YES;
                [dot setTag:i+1];
                UIButton * ButtonOnImageView = [[UIButton alloc]init];
                [ButtonOnImageView setFrame:CGRectMake(60,0,20,20)];
                [ButtonOnImageView setTag:i+1];
                [ButtonOnImageView setImage:[UIImage imageNamed:@"Delete-32.png"] forState:UIControlStateNormal];
                [ButtonOnImageView addTarget:self action:@selector(OnClickOfTheButton:) forControlEvents:UIControlEventTouchUpInside];
                [dot addSubview:ButtonOnImageView];
                [ButtonOnImageView setUserInteractionEnabled:YES];
                [self.image_scroll addSubview:dot];
            }
            else
            {
                if(i!=3)
                {
                NSLog(@"i in else %d",i);
                CGFloat xOrigin = i*90;
                _add =[[UIButton alloc] initWithFrame:CGRectMake(xOrigin,20,40,40)];
                [_add setImage:[UIImage imageNamed:@"PlusFilledNew-64.png"] forState:UIControlStateNormal];
                [_add addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
                [_add setUserInteractionEnabled:YES];
                [_add setTag:i+1];
                [self.image_scroll addSubview:_add];
                }
                
            }
        }
    }
    else
    {
        CGFloat xOrigin = 0;
        UIButton *add =[[UIButton alloc] initWithFrame:CGRectMake(xOrigin,20,40,40)];
        [add setImage:[UIImage imageNamed:@"PlusFilledNew-64.png"] forState:UIControlStateNormal];
        [add addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [add setUserInteractionEnabled:YES];
        [add setTag:1];
        [self.image_scroll addSubview:add];
    }
    
}
-(IBAction)onAddClick:(id)sender
{
    NSLog(@"add button clicked");
    [self performSelector:@selector(opengallery) withObject:self afterDelay:1.0 ];
}

-(IBAction)onSaveClick:(id)sender
{
    NSLog(@"SAVE CLICKED");
    if(_image_array.count!=0)
    {
        NSLog(@"move to next page %@",self.rootViewController);
        EnquirySubmitViewController *detailViewController = [[EnquirySubmitViewController alloc]
                                                             initWithNibName:@"EnquirySubmitViewController" bundle:nil];
        [detailViewController setRootViewController:self.rootViewController];
        detailViewController.image_array=_image_array;
        [self.rootViewController pushViewController:detailViewController animated:YES];
        
    }
    else{
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"IndiaPastForward"
                                                              message:@"Select atleast one image"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

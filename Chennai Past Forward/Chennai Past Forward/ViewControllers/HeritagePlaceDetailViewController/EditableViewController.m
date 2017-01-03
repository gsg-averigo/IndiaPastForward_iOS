//
//  EditableViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 14/01/16.
//  Copyright (c) 2016 Harish. All rights reserved.
//

#import "EditableViewController.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface EditableViewController ()

@end

@implementation EditableViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (IPAD)
    {
        self = [super initWithNibName:@"EditableViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"EditableViewController" bundle:nil];
    }
    
    if(self){
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.rootViewController.topvew.hidden = NO;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)previewAction:(id)sender
{
    
    int k =1;
    [[NSUserDefaults standardUserDefaults]setInteger:k forKey:@"Preview"];
    
    PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
    [detailViewController setRootViewController:self.rootViewController];
    
    detailViewController.imgUrl = _urlString;
    detailViewController.name = _name ;
     detailViewController.heritagePlaces=self.heritagePlaces;
    detailViewController.desc =[self stringByStrippingHTML];
    if ([editableTextView.text isEqualToString:@"Enter Text Here....."])
    {
        editableTextView.text = @"";
    }
    detailViewController.moretext = editableTextView.text;
    detailViewController.screendata = _screendata;
    NSLog(@"frame size %f",self.view.frame.size.width);
    NSLog(@"frame size %f",self.view.frame.size.height);
    [detailViewController.view setSize:self.view.frame.size];
    //[detailViewController.view setSize:CGSizeMake(320, 468)];
    [self.rootViewController pushViewController:detailViewController animated:YES];
    
    
}
-(NSString *) stringByStrippingHTML
{
    NSRange r;
    while ((r = [_desc rangeOfString:@"<[^>]+> " options:NSRegularExpressionSearch]).location != NSNotFound)
        _desc = [_desc stringByReplacingCharactersInRange:r withString:@""];
    NSLog(@"%@",_desc);
    return _desc;
}

#pragma mark - textview Delegates

-(BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:
(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView1 resignFirstResponder];
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        return NO;
    }
    
    
    if(range.length + range.location > textView1.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView1.text length] + [text length] - range.length;
    return newLength <= 250;
}
-(void)textViewDidBeginEditing:(UITextView *)textView1
{
    NSLog(@"Did begin editing");
    
    textView1.text =@"";
    [UIView beginAnimations:@"" context:@""];
    [UIView animateWithDuration:0.5 animations:nil];
    

    [UIView commitAnimations];
}
-(void)textViewDidChange:(UITextView *)textView1
{
    NSLog(@"Did Change");
    editableLabel.text = textView1.text;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView1
{
    NSLog(@"Did End editing");
    
    editableLabel.text = textView1.text;
    
}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    return UIInterfaceOrientationIsPortrait(orientation);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ViewController.m
//  NSOouPutStream
//
//  Created by czbk on 16/7/14.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import "FileDownload.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FileDownload *fileDown = [[FileDownload alloc]init];
    
    [fileDown downLoadWithPath:@"http://127.0.0.1/hao123.zip"];
}

@end

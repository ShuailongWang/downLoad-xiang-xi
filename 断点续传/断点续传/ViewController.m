//
//  ViewController.m
//  断点续传
//
//  Created by czbk on 16/7/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import "FileDownload.h"
#import "FileDownLoadManager.h"

@interface ViewController ()

@property (strong,nonatomic) FileDownload *down;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"...");
    
    
}

-(IBAction)clickDownButton:(UIButton*)sender{
    
//    [self.down downFileWithPath:@"http://127.0.0.1/222.zip"];
    
    
//    [self.down downloadFileWithUrl:@"http://127.0.0.1/222.zip" sucessBlock:^(NSString *loacPath) {
//        NSLog(@"loacPath %@",loacPath);
//        
//    } failBlock:^(NSError *error) {
//        
//        NSLog(@"error %@",error);
//    } progressBlock:^(float progress) {
//        
//        NSLog(@"progress %f",progress);
//    }];
    
    [[FileDownLoadManager sharedFileDownLoadManager]downLoadFilePath:@"http://127.0.0.1/222.zip" sucessBlock:^(NSString *filepath) {
        
        NSLog(@"loacPath %@",filepath);
    } failBlock:^(NSError *error) {
        
        NSLog(@"error %@",error);
    } progressBloak:^(float progress) {
        
        NSLog(@"progress %f",progress);
    }];
    
    
}

-(IBAction)pauseButton:(UIButton*)sender{
    [self.down pauseDownload];
}

-(FileDownload *)down{
    if(nil == _down){
        _down = [[FileDownload alloc]init];
    }
    return _down;
}

@end

//
//  ViewController.m
//  HEAD请求演示
//
//  Created by czbk on 16/7/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"...");
    
    //
    //[self headSync];
    
    [self headAsync];
}

//同步head请求
-(void)headSync{
    //中文转义
    //NSString *path = @"http://127.0.0.1/视频.zip";
//    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//舍弃了
    //path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //服务器的地址
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/hao123.zip"];
    
    //可变的请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"HEAD";
    
    //发送请求
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    //
    NSLog(@"%@",response);
    
}

//异步请求
-(void)headAsync{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/hao123.zip"];
    
    //
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //
    request.HTTPMethod = @"HEAD";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(nil == connectionError){
            NSLog(@"response -> %@",response);
            NSLog(@"data -> %@",data);
        }
    }];
}
@end

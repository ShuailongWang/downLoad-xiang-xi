//
//  FileDownload.m
//  GET请求下载文件
//
//  Created by czbk on 16/7/14.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "FileDownload.h"

@interface FileDownload()<NSURLConnectionDataDelegate>

@property (assign,nonatomic) long long expectedLength;  //文件的总大小
@property (assign,nonatomic) long long currentLength;   //已经下载的文件的大小


@property (strong,nonatomic) NSMutableData *dataM;
@end

@implementation FileDownload


-(void)downloadWithPath:(NSString*)path{
    //服务器地址
    NSURL *url = [NSURL URLWithString:path];
    
    //请求
    NSURLRequest  *request = [NSURLRequest requestWithURL:url];
    
    //设置NSURL 设置代理和代理方法执行是在同一个线程中的
    [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
        //
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        //开启子线程的消息循环
        [[NSRunLoop currentRunLoop] run];   //文件下载完成之后,消息循环会被代理自动关闭
        
    }];;
    
}

#pragma mark - 代理方法
//接受服务器的响应头信息
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //
    self.expectedLength = response.expectedContentLength;
}

//一点一点接受服务器返回的数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //已经接受的文件大小
    self.currentLength = self.currentLength + data.length;
    
    //
    float progress = (float)self.currentLength / self.expectedLength;
    NSLog(@"文件下载的进度%f",progress);
    
    
    //拼接数据
    [self.dataM appendData:data];
}

//数据接受完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"数据接受完成");
    
    //下载完毕后保存
    [self.dataM writeToFile:@"/Users/czbk/Desktop/hao.zip" atomically:YES];
}

//错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error %@",error);
}


-(NSMutableData *)dataM{
    if(nil == _dataM){
        _dataM = [NSMutableData data];
    }
    return _dataM;
}
@end

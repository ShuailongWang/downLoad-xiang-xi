//
//  FileDownload.m
//  断点续传
//
//  Created by czbk on 16/7/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "FileDownload.h"

@interface FileDownload()<NSURLConnectionDataDelegate>

@property (assign,nonatomic) long long totalLength;     //总
@property (assign,nonatomic) long long currentLength;   //当前的大小
@property (copy,nonatomic) NSString *localFilePath;     //本地文件路径
@property (strong,nonatomic) NSURLConnection *connection;   //发送请求

@property (copy,nonatomic) void(^sucessBlock)(NSString *loacPath);
@property (copy,nonatomic) void(^failBlock)(NSError *error);
@property (copy,nonatomic) void(^progressBlock)(float progress);
 
@end

@implementation FileDownload


-(void)pauseDownload{
    NSLog(@"暂停");
    [self.connection cancel];
}


-(void)downloadFileWithUrl:(NSString *)path sucessBlock:(void(^)(NSString *loacPath))sucessBlock failBlock:(void(^)(NSError *error))failBlock progressBlock:(void(^)(float progress))progressBlock{
    self.sucessBlock = sucessBlock;
    self.failBlock = failBlock;
    self.progressBlock = progressBlock;
    
    [self downFileWithPath:path];
}


/*
     断点续传
     1.获取服务器文件大小(同步)
     2.获取本地文件大小
     3.比较两个文件大小
     4.得到比较的结果再发送GET请求利用代理下载文件
 */
-(void)downFileWithPath:(NSString*)path{
    //服务器地址
    NSURL *url = [NSURL URLWithString:path];
    
    //MARK: 一,获取服务器文件的大小
    [self getServerFileSizeWithUrl:url];
    
    //MARK: 二,获取本地文件大小,并且跟服务的文件总大小进行比较
    self.currentLength = [self getLocalFileSize];
    
    //判断文件已经下载,直接返回
    if(self.currentLength == -1){
        if(self.sucessBlock){
            self.sucessBlock(self.localFilePath);
        }
        NSLog(@"文件已经下载.");
        return ;
    }
    
    //断点续传的方法
    [self breakPointResumWithUrl:url];
}

//断点续传
-(void)breakPointResumWithUrl:(NSURL*)urlPath{
    //创建请求
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:urlPath];
    
    /*在网页文件下载中,请求头里面有个Range字段.
     Range: bytes=x-y 表示从x字节下载到y字节
     Range: bytes=x- 表示从x字节下载到文件末尾.断点续传
     Range: bytes=-y 表示从头下载到y字节
     */
    //设置请求头信息
    [requestM setValue:[NSString stringWithFormat:@"bytes=%lld-",self.currentLength] forHTTPHeaderField:@"Range"];
    
    //异步
    [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
        //代理方法
        self.connection = [NSURLConnection connectionWithRequest:requestM delegate:self];
        
        //开启子线程循环
        [[NSRunLoop currentRunLoop] run];
    }];
}

//获取服务器文件的大小
-(void)getServerFileSizeWithUrl:(NSURL*)urlPath{
    
    //请求
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:urlPath];
    
    //请求方式,head只会返回请求头,不会返回请求行
    requestM.HTTPMethod = @"HEAD";
    
    //发送请求
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:requestM returningResponse:&response error:NULL];
    
    //服务器文件的大小
    self.totalLength = response.expectedContentLength;
    
}

//获取本地文件的大小,并且跟服务的文件总大小进行比较
-(long long)getLocalFileSize{
    //获取本地文件的总大小,NSFileManager
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //本地文件路径
    self.localFilePath = @"/users/czbk/desktop/ss.zip";
    
    //读取本地路径,把读出的文件以字典的形式保存
    NSDictionary *dict = [manager attributesOfItemAtPath:self.localFilePath error:NULL];
    
    //本地文件的大小
    long long localFileSize = dict.fileSize;
    
    //判断本地文件是否存在
    if([manager fileExistsAtPath:self.localFilePath]){
        //本地文件大小 == 服务器文件大小
        if(localFileSize == self.totalLength){
            return -1;
        }
        
        //本地文件大小 < 服务器文件大小
        if(localFileSize < self.totalLength){
            return localFileSize;
        }
        
        //本地文件大小 > 服务器文件大小
        if(localFileSize > self.totalLength){
            //删除文件
            [manager removeItemAtPath:self.localFilePath error:NULL];
            return 0;
        }
    }
    
    return 0;
}

#pragma mark - 代理方法
//接受服务器的响应头
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}

//传输中的数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //接受的数据
    self.currentLength = self.currentLength + data.length;
    
    float progress = (float)self.currentLength / self.totalLength;
    NSLog(@"%f",progress);
    
    if(self.progressBlock){
        self.progressBlock(progress);
    }
    
    //数据传输
    [self saveFileData:data];
}

//完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"数据接受完成.");
    if(self.sucessBlock){
        self.sucessBlock(self.localFilePath);
    }
}

//出错
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error -> %@",error);
    if(self.failBlock){
        self.failBlock(error);
    }
}


-(void)saveFileData:(NSData*)data{
    //1,获取文件路径
    NSString *path = @"/users/czbk/desktop/123.zip";
    
    //2,创建NSFileHandle对象
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    //3,判断要下载的文件是否存在
    if(handle == nil){
        //4,如果文件不存在,就新建文件,并保存
        [data writeToFile:path atomically:YES];
    }else{
        //5,如果文件存在,就继续在哪个文件中保存,并确定从哪里开始保存
        [handle seekToEndOfFile];
        
        //6,开始保存
        [handle writeabilityHandler];
        
        //7,保存完成后,关闭->句柄
        [handle closeFile];
    }
}













@end

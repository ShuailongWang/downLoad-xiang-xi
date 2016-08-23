//
//  FileDownload.m
//  filehadle
//
//  Created by czbk on 16/7/14.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "FileDownload.h"

@interface FileDownload()<NSURLConnectionDataDelegate>
@property (assign,nonatomic) long long total;   //总
@property (assign,nonatomic) long long currentLength;//当前大小

@property (strong,nonatomic) NSMutableData *dataM;  //缓存

@property (strong,nonatomic) NSOutputStream *stream;    //流

@end

@implementation FileDownload

-(void)downLoadWithPath:(NSString *)Path{
    //服务器地址
    NSURL *url = [NSURL URLWithString:Path];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        //开启子线程的消息循环
        [[NSRunLoop currentRunLoop] run];   //在文件下载完成之后,消息循环会被代理自动关闭
    }];
}


#pragma mark -代理方法

//接受服务器的相应头信息
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //文件的总大小
    self.total = response.expectedContentLength;
    
    //路径
    NSString *path = @"/Users/czbk/Desktop/hh.zip";
    
    //创建管道
    self.stream = [NSOutputStream outputStreamToFileAtPath:path append:YES];
    
    //代开管道
    [self.stream open];
}

//一点一点接受数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //接受的数据
    self.currentLength = self.currentLength + data.length;
    
    float progress = self.currentLength / self.total;
    
    NSLog(@"%f",progress);
    
    //保存到可变data中
    //[self.dataM appendData:data];
    
    //数据传输
    [self.stream write:data.bytes maxLength:data.length];
}

//数据接受完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"数据接受完成");
    
    //保存数据zip
    //[self.dataM writeToFile:@"/Users/czbk/Desktop/hh.zip" atomically:YES];
    
    //关闭管道
    [self.stream close];
}

//错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error -> %@",error);
}


//通过NSFileHandle保存到桌面
-(void)saveFileWithData:(NSData*)data{
    //MARK: 1,获取路径
    NSString *path = @"/Users/czbk/Desktop/hh.zip";
    
    //MARK: 2,NSFileHandle对象
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    //MARK: 3,判断要下载的文件是否存在
    if(nil == handle){
        //MARK: 4,如果文件不存在就继续在当前文件下保存,并确定从哪儿开始保存
        [data writeToFile:path atomically:YES];
    }else{
        //MARK: 5,如果文件存在就继续在当前文件不保存,并确定从哪儿开始保存
        [handle seekToEndOfFile];
        
        //MARK: 6,开始保存
        [handle writeData:data];
        
        //MARK: 7,保存完了以后要关闭NSFileHandle
        [handle closeFile];
    }
}


#pragma mark -懒加载
-(NSMutableData *)dataM{
    if(nil == _dataM){
        _dataM = [NSMutableData data];
    }
    return _dataM;
}
@end

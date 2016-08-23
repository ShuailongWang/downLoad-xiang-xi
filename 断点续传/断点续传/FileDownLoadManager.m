//
//  FileDownLoadManager.m
//  断点续传
//
//  Created by czbk on 16/7/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "FileDownLoadManager.h"
#import "FileDownload.h"

@implementation FileDownLoadManager


static id _instance;
+(instancetype)sharedFileDownLoadManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FileDownLoadManager alloc]init];
    });
    return _instance;
}

-(void)downLoadFilePath:(NSString *)path sucessBlock:(void(^)(NSString *filepath))sucessBlock failBlock:(void(^)(NSError *error))failBlock progressBloak:(void(^)(float progress))progressBloak{
    FileDownload *down = [[FileDownload alloc]init];
    
    [down downloadFileWithUrl:path sucessBlock:^(NSString *loacPath) {
        if(sucessBlock){
            sucessBlock(loacPath);
        }
        
    } failBlock:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
        
    } progressBlock:^(float progress) {
        if(progressBloak){
            progressBloak(progress);
        }
        
    }];
}

@end

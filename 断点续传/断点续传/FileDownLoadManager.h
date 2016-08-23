//
//  FileDownLoadManager.h
//  断点续传
//
//  Created by czbk on 16/7/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownLoadManager : NSObject


+(instancetype)sharedFileDownLoadManager;

-(void)downLoadFilePath:(NSString *)path sucessBlock:(void(^)(NSString *filepath))sucessBlock failBlock:(void(^)(NSError *error))failBlock progressBloak:(void(^)(float progress))progressBloak;

@end

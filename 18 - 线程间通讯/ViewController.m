//
//  ViewController.m
//  18 - 线程间通讯
//
//  Created by 肖晨 on 15/7/20.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];
    _imageView.backgroundColor = [UIColor cyanColor];
    
    [self.view addSubview:_imageView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelectorInBackground:@selector(download) withObject:nil];
    
}

- (void)download
{
    NSLog(@"获取URL");
    // 1. URL
    NSString *urlStr = @"http://www.thzer.com/uploadfile/2014/0604/20140604121024927.png";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"转为Data");
    // 2. Data
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:data];
    
    NSLog(@"返回数据给主线程");
//    [self performSelectorOnMainThread:@selector(downloadFinished:) withObject:image waitUntilDone:YES];
    [self.imageView performSelector:@selector(setImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
}

- (void)downloadFinished:(UIImage *)image
{
    NSLog(@"主线程下载");
    self.imageView.image = image;
}

@end

//
//  PreView.h
//  aasiBusiness
//
//  Created by superMan on 16/7/22.
//  Copyright © 2016年 zxyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PreView : UIView
@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;
//-(void)scanAnimation;
@end

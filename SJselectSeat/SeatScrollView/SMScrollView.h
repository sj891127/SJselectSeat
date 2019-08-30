//
//  SMScrollView.h
//  sijiedu
//
//  Created by sj on 2018/2/12.
//  Copyright © 2018年 sjjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMScrollView : UIScrollView
@property (nonatomic, assign) BOOL fitOnSizeChange;
@property (nonatomic, assign) BOOL upscaleToFitOnSizeChange;
@property (nonatomic, assign) BOOL stickToBounds;
@property (nonatomic, assign) BOOL centerZoomingView;
@property (nonatomic, strong, readonly) UIView *viewForZooming;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;
- (void)scaleToFit;
- (void)addViewForZooming:(UIView *)view;

@end

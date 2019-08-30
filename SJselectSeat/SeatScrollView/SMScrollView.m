//
//  SMScrollView.m
//  sijiedu
//
//  Created by sj on 2018/2/12.
//  Copyright © 2018年 sjjy. All rights reserved.
//

#import "SMScrollView.h"

@interface SMScrollView ()
@property (nonatomic, assign) CGSize prevBoundsSize;
@property (nonatomic, assign) CGPoint prevContentOffset;
@property (nonatomic, strong, readwrite) UIView *viewForZooming;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (weak, nonatomic) id scrollViewDelegate;

@end

@implementation SMScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self performInitialisation];
    }
    return self;
}

- (void)performInitialisation {
    self.prevBoundsSize = self.bounds.size;
    self.prevContentOffset = self.contentOffset;
    self.fitOnSizeChange = YES;
    self.upscaleToFitOnSizeChange = NO;
    self.stickToBounds = NO;
    self.centerZoomingView = YES;
    self.minimumZoomScale = 1.0;
    self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_doubleTapped:)];
    self.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleTapGestureRecognizer];
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
}

- (void)setZoomScale:(CGFloat)zoomScale {
    [super setZoomScale:zoomScale];
    self.contentSize = CGSizeMake(floorf(self.contentSize.width), floorf(self.contentSize.height));
}

- (void)scaleToFit {
    if (![self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) return
    [self _setMinimumZoomScaleToFit];
    self.zoomScale = self.minimumZoomScale;
}

- (void)addViewForZooming:(UIView *)view {
    if (self.viewForZooming) {
        [self.viewForZooming removeFromSuperview];
    }
    self.viewForZooming = view;
    [self addSubview:self.viewForZooming];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.prevBoundsSize, self.bounds.size)) {
        if (self.fitOnSizeChange) {
            [self scaleToFit];
        } else {
            [self _adjustContentOffset];
        }
        self.prevBoundsSize = self.bounds.size;
    }
    self.prevContentOffset = self.contentOffset;
}

- (void)_centerScrollViewContent {
    if (self.centerZoomingView && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
        CGRect frame = zoomView.frame;
        if (self.contentSize.width < self.bounds.size.width) {
            frame.origin.x = roundf((self.bounds.size.width - self.contentSize.width) / 2);
        } else {
            frame.origin.x = 0;
        }
        if (self.contentSize.height < self.bounds.size.height) {
            frame.origin.y = roundf((self.bounds.size.height - self.contentSize.height) / 2);
        } else {
            frame.origin.y = 0;
        }
        zoomView.frame = frame;
    }
}

- (void)_adjustContentOffset {
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
        CGPoint prevCenterPoint = (CGPoint){
            .x = (self.prevContentOffset.x + roundf(self.prevBoundsSize.width / 2) - zoomView.frame.origin.x) / self.zoomScale,
            .y = (self.prevContentOffset.y + roundf(self.prevBoundsSize.height / 2) - zoomView.frame.origin.y) / self.zoomScale,
        };
        if (self.stickToBounds) {
            if (self.contentSize.width > self.prevBoundsSize.width) {
                if (self.prevContentOffset.x == 0) {
                    prevCenterPoint.x = 0;
                } else if (self.prevContentOffset.x + self.prevBoundsSize.width == roundf(self.contentSize.width)) {
                    prevCenterPoint.x = zoomView.bounds.size.width;
                }
            }
            if (self.contentSize.height > self.prevBoundsSize.height) {
                if (self.prevContentOffset.y == 0) {
                    prevCenterPoint.y = 0;
                } else if (self.prevContentOffset.y + self.prevBoundsSize.height == roundf(self.contentSize.height)) {
                    prevCenterPoint.y = zoomView.bounds.size.height;
                }
            }
        }
        if (self.upscaleToFitOnSizeChange) {
            [self _increaseScaleIfNeeded];
        }
        CGPoint contentOffset = CGPointMake(0.0, 0.0);
        CGRect frame = zoomView.frame;
        if (self.contentSize.width > self.bounds.size.width) {
            frame.origin.x = 0;
            contentOffset.x = prevCenterPoint.x * self.zoomScale - roundf(self.bounds.size.width / 2);
            if (contentOffset.x < 0) {
                contentOffset.x = 0;
            } else if (contentOffset.x > self.contentSize.width - self.bounds.size.width) {
                contentOffset.x = self.contentSize.width - self.bounds.size.width;
            }
        }
        if (self.contentSize.height > self.bounds.size.height) {
            frame.origin.y = 0;
            contentOffset.y = prevCenterPoint.y * self.zoomScale - roundf(self.bounds.size.height / 2);
            if (contentOffset.y < 0) {
                contentOffset.y = 0;
            } else if (contentOffset.y > self.contentSize.height - self.bounds.size.height) {
                contentOffset.y = self.contentSize.height - self.bounds.size.height;
            }
        }
        zoomView.frame = frame;
        self.contentOffset = contentOffset;
    }
}

- (void)_increaseScaleIfNeeded {
    [self _setMinimumZoomScaleToFit];
    if (self.zoomScale < self.minimumZoomScale) {
        self.zoomScale = self.minimumZoomScale;
    }
}

- (void)_setMinimumZoomScaleToFit {
    UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
    CGSize scrollViewSize = self.bounds.size;
    CGSize zoomViewSize = zoomView.bounds.size;
    CGFloat scaleToFit = fminf(scrollViewSize.width / zoomViewSize.width, scrollViewSize.height / zoomViewSize.height);
    if (scaleToFit > 1.0) {
        scaleToFit = 1.0;
    }else if (scaleToFit <0.7) {
        scaleToFit = 0.7;
    }
    scaleToFit = 1.0;
    self.minimumZoomScale = scaleToFit;
}

//点击放缩
- (void)_doubleTapped:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
        if (self.zoomScale == self.minimumZoomScale) {
            CGFloat newScale = self.maximumZoomScale;
            CGPoint centerPoint = [gestureRecognizer locationInView:zoomView];
            CGRect zoomRect = [self _zoomRectInView:self forScale:newScale withCenter:centerPoint];
            [self zoomToRect:zoomRect animated:YES];
        } else {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }
    }
}

- (CGRect)_zoomRectInView:(UIView *)view forScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = view.bounds.size.height / scale;
    zoomRect.size.width = view.bounds.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    [super setDelegate:delegate];
    self.scrollViewDelegate = delegate;
}

@end

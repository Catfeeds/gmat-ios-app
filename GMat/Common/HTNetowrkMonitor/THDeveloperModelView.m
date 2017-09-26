//
//  THDeveloperModelView.m
//  TingApp
//
//  Created by hublot on 2017/1/5.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "THDeveloperModelView.h"

@interface THDeveloperModelView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isDeveloperModel;

@property (nonatomic, assign) CGPoint fpsLabelOriginPoint;

@property (nonatomic, assign) BOOL isDragedFpsLabel;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) HTFPSLabel *fpsLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextView *textView;

@end

static THDeveloperModelView *developerModelView;

@implementation THDeveloperModelView

+ (instancetype)defaultDeveloperModelView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        developerModelView = [[THDeveloperModelView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        [developerModelView addSubview:developerModelView.tableView];
        [developerModelView addSubview:developerModelView.textView];
        [developerModelView addSubview:developerModelView.fpsLabel];
        developerModelView.tableView.hidden = true;
        developerModelView.textView.hidden = true;
    });
    return developerModelView;
}

+ (BOOL)isDeveloperModel {
	return [THDeveloperModelView defaultDeveloperModelView].isDeveloperModel;
}

+ (void)updateDeveloperModelView {
    BOOL isDeveloperModel = [[NSUserDefaults standardUserDefaults] boolForKey:@"developer_mode_enable"];
	
	isDeveloperModel = false;
	
    if ([THDeveloperModelView defaultDeveloperModelView].isDeveloperModel == isDeveloperModel) {
        return;
    }
    developerModelView.isDeveloperModel = isDeveloperModel;
    if (isDeveloperModel) {
        [[UIApplication sharedApplication].keyWindow addSubview:developerModelView];
    } else {
        [developerModelView removeFromSuperview];
    }
}

+ (void)receiveNetworkResponse:(id)networkResponse {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm:ss.SSS"];
	NSString *networkResponseString = @"nil";
	@try {
		networkResponseString = [NSString stringWithFormat:@"%@", networkResponse];
	} @catch (NSException *exception) {
		networkResponseString = @"解析出错";
	} @finally {
		networkResponseString = networkResponseString.length ? networkResponseString : @"nil";
	}
	NSDictionary *modelDictionary = @{@"title":[formatter stringFromDate:[NSDate date]], @"detail":networkResponseString};
	[[THDeveloperModelView defaultDeveloperModelView].modelArray addObject:modelDictionary];
	NSIndexPath *indexPath = developerModelView.tableView.indexPathForSelectedRow;
	if (!indexPath) {
		indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	}
	[developerModelView.tableView reloadData];
	[developerModelView.tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
	[developerModelView tableView:developerModelView.tableView didSelectRowAtIndexPath:indexPath];
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:developerModelView.modelArray.count - 1 inSection:0];
	[developerModelView.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *superHitTestView = [super hitTest:point withEvent:event];
	if (superHitTestView == self.fpsLabel || superHitTestView == self.textView || superHitTestView == self.tableView || [NSStringFromClass([superHitTestView class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([superHitTestView class]) isEqualToString:@"UITextRangeView"]) {
        return superHitTestView;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.modelArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.textView.text = self.modelArray[indexPath.row][@"detail"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.fpsLabel.frame, location)) {
        self.fpsLabelOriginPoint = location;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!CGPointEqualToPoint(self.fpsLabelOriginPoint, CGPointZero)) {
        CGPoint location = [touches.anyObject locationInView:self];
        self.fpsLabel.frame = CGRectMake(self.fpsLabel.frame.origin.x + location.x - self.fpsLabelOriginPoint.x, self.fpsLabel.frame.origin.y + location.y - self.fpsLabelOriginPoint.y, self.fpsLabel.bounds.size.width, self.fpsLabel.bounds.size.height);
        self.fpsLabelOriginPoint = location;
        self.isDragedFpsLabel = true;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    CGPoint location = [touches.anyObject locationInView:self];
    if (self.isDragedFpsLabel) {
        [UIView animateWithDuration:0.1 animations:^{
            self.fpsLabel.frame = CGRectMake(MAX(0, MIN(self.fpsLabel.frame.origin.x, self.bounds.size.width - self.fpsLabel.frame.size.width)), MAX(0, MIN(self.fpsLabel.frame.origin.y, self.bounds.size.height - self.fpsLabel.frame.size.height)), self.fpsLabel.bounds.size.width, self.fpsLabel.bounds.size.height);
        } completion:nil];
        self.isDragedFpsLabel = false;
    } else {
        if (CGRectContainsPoint(self.fpsLabel.frame, location)) {
            self.textView.hidden = !self.textView.hidden;
            self.tableView.hidden = self.textView.hidden;
        }
    }
    self.fpsLabelOriginPoint = CGPointZero;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (HTFPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[HTFPSLabel alloc] initWithFrame:CGRectZero];
    }
    return _fpsLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(self.tableView.bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width - self.tableView.bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.alwaysBounceVertical = true;
        _textView.editable = false;
    }
    return _textView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.35, [UIScreen mainScreen].bounds.size.height - 64)];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];
    }
    return _tableView;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [@[] mutableCopy];
    }
    return _modelArray;
}

@end

@interface HTFPSLabel ()

@end

#define HTFPSLabelDefaultSize CGSizeMake(50, 50)

@implementation HTFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    NSTimeInterval _llll;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [_link invalidate];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = HTFPSLabelDefaultSize;
    }
    self = [super initWithFrame:frame];
    
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = true;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    [_link invalidate];
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.layer.masksToBounds = true;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return HTFPSLabelDefaultSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, text.length - 3)];
    [text addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(text.length - 3, 3)];
    [text addAttributes:@{NSFontAttributeName:_font} range:NSMakeRange(0, text.length)];
    [text addAttributes:@{NSFontAttributeName:_subFont} range:NSMakeRange(text.length - 4, 1)];
    self.attributedText = text;
}

@end

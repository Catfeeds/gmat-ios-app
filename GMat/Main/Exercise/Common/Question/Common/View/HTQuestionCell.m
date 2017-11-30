//
//  HTQuestionCell.m
//  GMat
//
//  Created by hublot on 2016/11/9.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTQuestionCell.h"
#import "NSString+HTString.h"
#import "NSAttributedString+HTAttributedString.h"
#import "NSTextAttachment+HTTextAttachment.h"
#import "NSMutableAttributedString+HTMutableAttributedString.h"
#import <NSObject+HTTableRowHeight.h>

#define HTQuestionCellOfChapeLayerEdgeDetailLabel HTADAPT568(6)

#define HTQuestionCellOfCellEdgeShapeLayer HTADAPT568(6)

@interface HTQuestionCell ()

@property (nonatomic, strong) UIButton *titleNameButton;

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation HTQuestionCell

- (void)dealloc {
    
}

- (void)didMoveToSuperview {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self.contentView.layer addSublayer:self.backgroundLayer];
	[self.contentView addSubview:self.titleNameButton];
	[self.contentView addSubview:self.detailTextView];
	[self.titleNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self).offset(HTADAPT568(7));
		make.centerX.mas_equalTo(self.mas_left).offset(HTADAPT568(20));
	}];
	[self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(HTADAPT568(35) + HTQuestionCellOfChapeLayerEdgeDetailLabel);
		make.right.mas_equalTo(self).offset(- HTQuestionCellOfCellEdgeShapeLayer - HTQuestionCellOfChapeLayerEdgeDetailLabel);
		make.top.mas_equalTo(self).offset(HTQuestionCellOfCellEdgeShapeLayer + HTQuestionCellOfChapeLayerEdgeDetailLabel);
		make.bottom.mas_equalTo(self).offset(- HTQuestionCellOfCellEdgeShapeLayer - HTQuestionCellOfChapeLayerEdgeDetailLabel);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGFloat cornerRadius = 3;
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	NSArray *roundPointArray = @[
								 [NSValue valueWithCGPoint:CGPointMake(self.detailTextView.ht_x - HTQuestionCellOfChapeLayerEdgeDetailLabel + cornerRadius, self.detailTextView.ht_y - HTQuestionCellOfChapeLayerEdgeDetailLabel + cornerRadius)],
								 [NSValue valueWithCGPoint:CGPointMake(self.detailTextView.ht_x + HTQuestionCellOfChapeLayerEdgeDetailLabel - cornerRadius + self.detailTextView.ht_w, self.detailTextView.ht_y - HTQuestionCellOfChapeLayerEdgeDetailLabel + cornerRadius)],
								 [NSValue valueWithCGPoint:CGPointMake(self.detailTextView.ht_x + HTQuestionCellOfChapeLayerEdgeDetailLabel - cornerRadius + self.detailTextView.ht_w, self.detailTextView.ht_y + HTQuestionCellOfChapeLayerEdgeDetailLabel - cornerRadius + self.detailTextView.ht_h)],
								 [NSValue valueWithCGPoint:CGPointMake(self.detailTextView.ht_x - HTQuestionCellOfChapeLayerEdgeDetailLabel + cornerRadius, self.detailTextView.ht_y + HTQuestionCellOfChapeLayerEdgeDetailLabel - cornerRadius + self.detailTextView.ht_h)]
								 ];
	[roundPointArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[bezierPath addArcWithCenter:[obj CGPointValue] radius:cornerRadius startAngle:M_PI + M_PI_2 * idx endAngle:M_PI + M_PI_2 * (idx + 1) clockwise:true];
	}];
	[bezierPath moveToPoint:CGPointMake(self.detailTextView.ht_x - HTQuestionCellOfChapeLayerEdgeDetailLabel, self.detailTextView.ht_y - HTQuestionCellOfChapeLayerEdgeDetailLabel + cornerRadius)];
	[bezierPath addLineToPoint:CGPointMake(self.detailTextView.ht_x - HTQuestionCellOfChapeLayerEdgeDetailLabel, self.titleNameButton.ht_cy - 3)];
	[bezierPath addLineToPoint:CGPointMake(self.detailTextView.ht_x - 5 - HTQuestionCellOfChapeLayerEdgeDetailLabel, self.titleNameButton.ht_cy)];
	[bezierPath addLineToPoint:CGPointMake(self.detailTextView.ht_x - HTQuestionCellOfChapeLayerEdgeDetailLabel, self.titleNameButton.ht_cy + 3)];
	[bezierPath addLineToPoint:CGPointMake(self.detailTextView.ht_x - HTQuestionCellOfChapeLayerEdgeDetailLabel, self.detailTextView.ht_y + HTQuestionCellOfChapeLayerEdgeDetailLabel - cornerRadius + self.detailTextView.ht_h)];
	self.backgroundLayer.path = bezierPath.CGPath;
}

- (void)setModel:(NSAttributedString *)model row:(NSInteger)row {
	[self.titleNameButton setTitle:[NSString stringWithFormat:@"%c", (char)('A' + row)] forState:UIControlStateNormal];
	self.detailTextView.attributedText = model;
	CGFloat detailNameLabelHeight = [self.detailTextView.attributedText ht_attributedStringHeightWithWidth:HTSCREENWIDTH - HTADAPT568(35) - HTQuestionCellOfChapeLayerEdgeDetailLabel * 2 - HTQuestionCellOfCellEdgeShapeLayer - 30 textView:self.detailTextView];
    CGFloat modelHeight = MAX(detailNameLabelHeight + HTQuestionCellOfChapeLayerEdgeDetailLabel + HTQuestionCellOfCellEdgeShapeLayer + HTADAPT568(20), 50);
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (void)setCellSelectedColor:(UIColor *)cellSelectedColor {
	_cellSelectedColor = cellSelectedColor;
	[self.titleNameButton setBackgroundImage:[[[UIImage ht_pureColor:cellSelectedColor] ht_resetSize:CGSizeMake(HTADAPT568(16), HTADAPT568(16))] ht_imageByRoundCornerRadius:HTADAPT568(8) corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound] forState:UIControlStateNormal];
	self.backgroundLayer.strokeColor = cellSelectedColor.CGColor;
	[self.detailTextView.textStorage addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle]} range:NSMakeRange(0, self.detailTextView.textStorage.length)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (!self.userInteractionEnabled) {
		return;
	}
	[super setSelected:selected animated:animated];
	[self setCellSelectedColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]];
	[self.titleNameButton setBackgroundImage:[[[UIImage ht_pureColor:selected ? [UIColor ht_colorStyle:HTColorStylePrimaryTheme] : [UIColor ht_colorString:@"99999a"]] ht_resetSize:CGSizeMake(HTADAPT568(16), HTADAPT568(16))] ht_imageByRoundCornerRadius:HTADAPT568(8) corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound] forState:UIControlStateNormal];
	self.backgroundLayer.strokeColor = selected ? [UIColor ht_colorStyle:HTColorStylePrimaryTheme].CGColor : [UIColor ht_colorStyle:HTColorStylePrimarySeparate].CGColor;
	[self.detailTextView.textStorage addAttributes:@{NSForegroundColorAttributeName:selected ? [UIColor ht_colorStyle:HTColorStylePrimaryTitle] : [UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(0, self.detailTextView.textStorage.length)];
}

- (UIButton *)titleNameButton {
	if (!_titleNameButton) {
		_titleNameButton = [[UIButton alloc] init];
		_titleNameButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleSmall];
		[_titleNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_titleNameButton setBackgroundImage:[[[UIImage ht_pureColor:[UIColor ht_colorString:@"99999a"]] ht_resetSize:CGSizeMake(HTADAPT568(16), HTADAPT568(16))] ht_imageByRoundCornerRadius:HTADAPT568(8) corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound] forState:UIControlStateNormal];
		_titleNameButton.userInteractionEnabled = false;
	}
	return _titleNameButton;
}

- (UITextView *)detailTextView {
	if (!_detailTextView) {
		_detailTextView = [[UITextView alloc] init];
		_detailTextView.textContainerInset = UIEdgeInsetsZero;
		_detailTextView.editable = false;
		_detailTextView.selectable = false;
		_detailTextView.userInteractionEnabled = false;
	}
	return _detailTextView;
}

- (CAShapeLayer *)backgroundLayer {
	if (!_backgroundLayer) {
		_backgroundLayer = [CAShapeLayer layer];
		_backgroundLayer.fillColor = [UIColor clearColor].CGColor;
		_backgroundLayer.lineWidth = 1;
	}
	return _backgroundLayer;
}

@end

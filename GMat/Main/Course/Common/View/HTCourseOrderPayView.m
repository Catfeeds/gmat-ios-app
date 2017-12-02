//
//  HTCourseOrderPayView.m
//  GMat
//
//  Created by hublot on 2016/11/17.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCourseOrderPayView.h"
#import "HTWebController.h"

@implementation HTCourseOrderPayView

- (void)didMoveToSuperview {
	[self addSubview:self.sumPriceLabel];
	[self addSubview:self.alipayButton];
	[self.sumPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self);
		make.left.mas_equalTo(self).offset(HTADAPT568(50));
		make.right.mas_equalTo(self.alipayButton.mas_left);
		make.bottom.mas_equalTo(self);
	}];
	[self.alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.sumPriceLabel.mas_right);
		make.width.mas_equalTo(self).multipliedBy(0.4);
		make.right.mas_equalTo(self);
		make.top.bottom.mas_equalTo(self);
	}];
}

- (void)setModel:(HTCourseOrderModel *)model {
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计: ¥%@", model.price]];
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(4, attributedString.length - 4)];
	self.sumPriceLabel.attributedText = attributedString;
	self.alipayButton.enabled = !model.order_status.integerValue;
	[self.alipayButton ht_whenTap:^(UIView *view) {
		
		NSString *requestBody = [NSString stringWithFormat:@"WIDout_trade_no=%@&WIDsubject=%@&WIDtotal_fee=%@&WIDbody=App Web支付&WIDshow_url=www.gmatonline.cn&service=WAP", model.order_id, model.data.contenttitle, model.price];
		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gmatonline.cn/alipay/alipayapi.php"]];
		urlRequest.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
		urlRequest.HTTPMethod = @"POST";
		
		HTWebController *webController = [[HTWebController alloc] initWithRequest:urlRequest];
		[self.ht_controller.navigationController pushViewController:webController animated:true];
	}];
}

- (UILabel *)sumPriceLabel {
	if (!_sumPriceLabel) {
		_sumPriceLabel = [[UILabel alloc] init];
		_sumPriceLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
		_sumPriceLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"合计: ¥0"];
		[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(4, attributedString.length - 4)];
		_sumPriceLabel.attributedText = attributedString;
	}
	return _sumPriceLabel;
}

- (UIButton *)alipayButton {
	if (!_alipayButton) {
		_alipayButton = [[UIButton alloc] init];
		_alipayButton.enabled = false;
		[_alipayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_alipayButton setTitle:@"支付宝支付" forState:UIControlStateNormal];
		[self.alipayButton setTitle:@"已经购买" forState:UIControlStateDisabled];
		_alipayButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		[_alipayButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]] forState:UIControlStateNormal];
		[_alipayButton setBackgroundImage:[UIImage ht_pureColor:[UIColor grayColor]] forState:UIControlStateDisabled];
		[_alipayButton setBackgroundImage:[UIImage ht_pureColor:[UIColor ht_colorString:@"5f88c1"]] forState:UIControlStateHighlighted];
	}
	return _alipayButton;
}


@end

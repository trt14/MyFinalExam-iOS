/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

typedef NSString *FBSDKURLScheme NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(URLScheme);

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeFacebookApp
  DEPRECATED_MSG_ATTRIBUTE("`URLScheme.facebookApp` is deprecated and will be removed in the next major release; please use `URLScheme.facebookAPI` instead");

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeFacebookAPI;

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeFacebookShareExtension
  DEPRECATED_MSG_ATTRIBUTE("`URLScheme.facebookShareExtension` is deprecated and will be removed in the next major release; please use `URLScheme.facebookAPI` instead");

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeMessengerApp;

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeMasqueradePlayer
  DEPRECATED_MSG_ATTRIBUTE("`URLScheme.masqueradePlayer` is deprecated and will be removed in the next major release");

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeHTTPS NS_SWIFT_NAME(https);

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeHTTP NS_SWIFT_NAME(http);

FOUNDATION_EXPORT FBSDKURLScheme const FBSDKURLSchemeWeb;

# Tweeper

This is a demo project for Twitter REST API written in Swift

Please note that you will need to use your own consumer key and secret, which you can obtain from dev.twitter.com

Currently using: Alamofire (AFNetworking in Swift), SwiftyJSON, ASToolkit


## INSTALLATION

##### 1  You'll need to supply your own consumer key and consumer secret strings directly into the source code.

Create a struct named Consumer with two static String constants in a Consumer.swift file under Files/ directory.

```
struct Consumer
{
  static let consumerKey = " ... "
  static let consumerSecret = " ... "
}
```

The Twitter class needs these values to obtain application-only authentication, see `https://dev.twitter.com/oauth/application-only`


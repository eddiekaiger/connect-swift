# ElizaSwiftPackageApp example

This example app imports the `Connect` library using CocoaPods,
and provides an interface for
[chatting with Eliza](https://connect.build/demo).

The app has support for chatting using a variety of protocols supported by
the Connect library:

- [Connect](https://connect.build) + unary
- [Connect](https://connect.build) + streaming
- [gRPC-Web](https://grpc.io) + unary
- [gRPC-Web](https://grpc.io) + streaming

## Try it out

1. Ensure you have CocoaPods installed (`brew install cocoapods`)
2. `cd` into this directory and install the pods (`pod install`)
3. Open the generated `.xcworkspace` file (`xed .`)
4. Build the app target using Xcode

Note that the [`Podfile`](./Podfile) uses a local path reference to the
Connect library in this repository, rather than the one in the CocoaPods
specs repo.
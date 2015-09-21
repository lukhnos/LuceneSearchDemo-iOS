A Sample Lucene App for iOS
===========================

This is the iOS version of [lucenestudy](https://github.com/lukhnos/lucenestudy/tree/mobile).
It depends on the mobile branch of that project, which in turn comes with
prebuilt JARs of [Mobile Lucene](https://github.com/lukhnos/mobilelucene),
an experimental port of Lucene to Objective-C.

To build the app, first make sure you have the submodules checked out:

    git submodule update --init --recursive

Next, you need to download j2objc and place the unzipped files to
`vendor/j2objc`. The script `setup-j2objc.sh` can do that for you:

    ./setup-j2objc.sh

Then, use the Xcode project to build the app target.

For more information about the app and its data source, please visit the
[lucenestudy](https://github.com/lukhnos/lucenestudy/tree/mobile) project.

The app is also available on [the App Store](https://itunes.apple.com/us/app/film-review-search-lucene/id1039258169?mt=8).

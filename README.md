A Sample Lucene App for iOS
===========================

The app is available on [the App Store](https://itunes.apple.com/us/app/film-review-search-lucene/id1039258169?mt=8).

This is the iOS version of [lucenestudy](https://github.com/lukhnos/lucenestudy/tree/mobile).
It depends on the mobile branch of that project, which in turn comes with
prebuilt JARs of [Mobile Lucene](https://github.com/lukhnos/mobilelucene),
an experimental port of Lucene to Objective-C.

It also has [an Android version](https://github.com/lukhnos/LuceneSearchDemo-Android).

To build the app, first make sure you have the submodules checked out:

    git submodule update --init --recursive

Next, set up the J2ObjC dependencies. If you haven't installed it,
[download version 2.8](https://github.com/google/j2objc/releases/tag/2.8) from
its GitHub releases page. After you have made sure that the command `j2objc`
exists in your `PATH`, run:

    ./setup-j2objc.sh

Then, use the Xcode project to build the app target.

For more information about the app and its data source, please visit the
[lucenestudy](https://github.com/lukhnos/lucenestudy/tree/mobile) project.

# Outdated!!

This project handles the build-process in a clumpsy manner. Check out 
[this newer](https://github.com/kristianlm/chicken-android) version instead!

I'll still leave it out if people want to look at it.

## Interactive Chicken Scheme on Android 

A small template for developing Chicken apps/games interactively on
Android. The template currently features:

1. OpenGL ES bindings
1. Remote REPL (on port 1234)

This sample will start a OpenGL activity and evaluate your
`/sdcard/live-update.scm` file which you can replace in a running
session (to be replaced by remote-repl). You can `adb push live-update.scm /sdcard/` during
a running sessions and see the effect of the new `live-update` definition immediately.

More interestingly, you can also connect to a running repl on port 1234:

    $ adb forward tcp:1234 tcp:1234
    $ echo "(glDisable GL_BLEND)" | nc localhost 1234

Transparency should immediately be turned off. You can easily set up Emacs
to use this repl by doing `M-x nc localhost 1234` (use `C-q` to force inserting spaces).

This template lets the Android NDK do the hard work of
cross-compilation, and the chicken sources are included in the repo. 
It is heavily based on the native-activity sample
application found in the Android NDK.

Check out my separate makefile project for building Chicken on Android 
[here](https://github.com/kristianlm/chicken-android).

## Requirements

  [Chicken Scheme]: http://call-cc.org
  [Android NDK]: http://developer.android.com/sdk/ndk/index.html
  [Chicken Bind]: http://wiki.call-cc.org/eggref/4/bind
  

* [Chicken Scheme] \(I'm on 4.7.0.4) 
* [Chicken Bind]
* [Android NDK] \(I'm on `android-ndk-r7`)


## Build steps

#### Convert gl-bind.h into gl-bind.scm
If you don't have it already, do `chicken-install bind `. Then do

    chicken-bind -export-constants headers/gl-bind.h

A `./headers/gl-bind.scm` should be spit out.

#### Compile loop.scm -> loop.c and others with:

    $ cd android-chicken
    $ csc -t jni/*.scm

#### Build the native part of the app:

    $ <NDK-PATH>/ndk-build -j 4 # 4 processes for speedy compilation

This should place a `libnative-activity.so` file under `./libs/armeabi`

#### Upload interpreted code-snippets

The app is looking for additional sources in the `/sdcard` directory of your phone. 
These make debugging more convenient because you can replace them and they will re-load a runtime.

    $ for f in sdcard/*.scm ; do adb push $f /sdcard/ ; done

Obviously, these should be compiled into the app once testing is over.

#### Build & Install the APK as usual

    $ android update project -p . -t android-10
    $ ant clean debug # clean to make sure .so file is replaced
    $ adb install bin/NativeActivity-debug.apk
    $ adb forward tcp:1234 tcp:1234 # phone's repl at localhost:1234

Launch the app and press the screen for it to start.

# Interactive Chicken Scheme on Android 

A small template for developing Chicken apps/games interactively on
Android. This template is heavily based on the native-activity sample
application found in the Android NDK.

OBS: OpenGL bindings c<->Chicken is currently at 'TODO'.

This sample will start a OpenGL activity and evaluate your
`/sdcard/live-update.scm` file which you can replace in a running
session.

This template let's the Android NDK do the hard work of
cross-compilation, and the chicken sources are included in the repo.

## Build steps

#### Compile loop.scm -> loop.c with:

    $ cd android-chicken
    $ csc -t jni/loop.scm

#### Build the native part of the app:

    $ <NDK-PATH>/ndk-build -j 4 # 4 processes for speedy compilation

This should place a `libnative-activity.so` file under `./libs/armeabi`

#### Build & Install the APK as usual

    $ android update project -p . -t android-10
    $ ant debug
    $ adb install bin/NativeActivity-debug.apk
    
    

## Notes

The example only prints out to stdout. This will not normally show up
in your logcat. To have Android pipe stdout to logcat, see http://developer.android.com/guide/developing/tools/adb.html#stdout.

Note that this `stdout->logcat` feature seems to be buffering. You may have to wait for
something to appear.



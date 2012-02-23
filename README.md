# Interactive Chicken Scheme on Android 

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


## Build steps

#### Convert gl-bind.h into gl-bind.scm
If you don't have it already, do `chicken-install bind `. Then do

    chicken-bind ./headers/gl-bind.h

A `./headers/gl-bind.scm` should be spit out.

#### Compile loop.scm -> loop.c and others with:

    $ cd android-chicken
    $ csc -t jni/*.scm

#### Build the native part of the app:

    $ <NDK-PATH>/ndk-build -j 4 # 4 processes for speedy compilation

This should place a `libnative-activity.so` file under `./libs/armeabi`

#### Build & Install the APK as usual

    $ android update project -p . -t android-10
    $ ant debug
    $ adb install bin/NativeActivity-debug.apk

Launch the app and press the screen for it to start.



csc -t jni/*.scm && /opt/android-ndk-r7/ndk-build -j 4  && ant clean debug && adb install -r bin/NativeActivity-debug.apk 

# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := native-activity

LOCAL_SRC_FILES := \
	main.c \
	gl-utils.c \
	loop.c\
	posix-extract.c\
\
	chicken-4.7.0.5/runtime.c \
	chicken-4.7.0.5/library.c \
	chicken-4.7.0.5/ports.c \
	chicken-4.7.0.5/eval.c \
	chicken-4.7.0.5/expand.c \
	chicken-4.7.0.5/tcp.c \
	chicken-4.7.0.5/extras.c \
	chicken-4.7.0.5/scheduler.c \
	chicken-4.7.0.5/data-structures.c \
	chicken-4.7.0.5/chicken-syntax.c \
	chicken-4.7.0.5/srfi-1.c \
	chicken-4.7.0.5/srfi-18.c

LOCAL_LDLIBS    := -llog -landroid -lEGL -lGLESv1_CM
LOCAL_STATIC_LIBRARIES := android_native_app_glue

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/native_app_glue)

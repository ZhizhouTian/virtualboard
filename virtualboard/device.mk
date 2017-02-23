#
# Copyright (C) 2011 The Android Open-Source Project
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

# Adjust the dalvik heap to be appropriate for a tablet.
$(call inherit-product-if-exists, frameworks/base/build/tablet-dalvik-heap.mk)
$(call inherit-product-if-exists, frameworks/native/build/tablet-dalvik-heap.mk)

# Use our own init.rc
#
TARGET_PROVIDES_INIT_RC := true
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
			system/core/rootdir/init.rc:root/init.rc \
			$(LOCAL_PATH)/init.virtualboardu.rc:root/init.virtualboardu.rc \
			$(LOCAL_PATH)/fstab.virtualboardu:root/fstab.virtualboardu \
			$(LOCAL_PATH)/ueventd.virtualboardu.rc:root/ueventd.virtualboardu.rc)

PRODUCT_COPY_FILES += system/core/rootdir/init.zygote64_32.rc:root/init.zygote64_32.rc

# Use our keyboard layout, whereby F1 and F10 are menu buttons.
#
#PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
#                        $(LOCAL_PATH)/../common/arm.kl:system/usr/keylayout/fvp_model.kl \
#                        $(LOCAL_PATH)/../common/media_codecs.xml:system/etc/media_codecs.xml \
#                        )

PRODUCT_PACKAGES += gralloc.default.aosp

#
# Inherit the full_base and device configurations

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.zygote=zygote64_32

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/virtualboard/virtualboard/device.mk)

#
# Overrides
PRODUCT_NAME := virtualboard
PRODUCT_DEVICE := virtualboard
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on Linaro arm64 Emulator

PRODUCT_PACKAGES += libGLES_android

PRODUCT_RUNTIMES := runtime_libart_default runtime_libdvm

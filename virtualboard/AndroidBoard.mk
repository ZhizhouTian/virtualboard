LOCAL_PATH := $(call my-dir)

ifneq ($(strip $(TARGET_NO_KERNEL)),true)
KERNEL_OUT := $(OUT)/obj/KERNEL
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/Image
JOBS := $(shell $(cat /proc/cpuinfo | grep processor | wc -l))

$(TARGET_PREBUILT_KERNEL):
	mkdir -p $(KERNEL_OUT)
	$(MAKE) -C kernel ARCH=$(TARGET_ARCH) O=$(KERNEL_OUT) $(KERNEL_DEFCONFIG)
	$(MAKE) -C kernel ARCH=$(TARGET_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) O=$(KERNEL_OUT) -j${JOBS}

out/target/product/$(TARGET_PRODUCT)/kernel: $(TARGET_PREBUILT_KERNEL)
	out/host/linux-x86/bin/acp $(TARGET_PREBUILT_KERNEL) $(OUT)/kernel

endif # End of Kernel

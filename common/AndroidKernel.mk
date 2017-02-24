KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL
KERNEL_CONFIG := $(KERNEL_OUT)/.config
KERNEL_MODULES_OUT := $(TARGET_ROOT_OUT)/lib/modules
KERNEL_USR_HEADERS := $(KERNEL_OUT)/usr

JOBS := $(shell if [ $(cat /proc/cpuinfo | grep processor | wc -l) -gt 8 ]; then echo 8; else echo 4; fi)
TARGET_PREBUILT_KERNEL :=  $(KERNEL_OUT)/arch/$(TARGET_KERNEL_ARCH)/boot/Image

$(KERNEL_OUT):
	@echo "==== Start Kernel Compiling ... ===="

$(KERNEL_CONFIG): kernel/arch/$(TARGET_KERNEL_ARCH)/configs/$(KERNEL_DEFCONFIG)
	echo "KERNEL_OUT = $KERNEL_OUT,  KERNEL_DEFCONFIG = $KERNEL_DEFCONFIG"
	mkdir -p $(KERNEL_OUT)
	$(MAKE) ARCH=$(TARGET_KERNEL_ARCH) -C kernel O=../$(KERNEL_OUT) $(KERNEL_DEFCONFIG)

define  sprd_create_user_config 
	$(shell ./kernel/scripts/sprd_create_user_config.sh $(1) $(2))
endef

ifeq ($(TARGET_BUILD_VARIANT),user)
DEBUGMODE := BUILD=no
USER_CONFIG := $(TARGET_OUT)/dummy
TARGET_DEVICE_USER_CONFIG := $(PLATCOMM)/user_diff_config
$(USER_CONFIG) : $(KERNEL_CONFIG)
	$(call sprd_create_user_config, $(KERNEL_CONFIG), $(TARGET_DEVICE_USER_CONFIG))
	$(call sprd_create_user_config, $(KERNEL_CONFIG), $(TARGET_BOARD_SPEC_CONFIG))
else
DEBUGMODE := $(DEBUGMODE)
USER_CONFIG  := $(TARGET_OUT)/dummy
$(USER_CONFIG) : $(KERNEL_CONFIG)
	$(call sprd_create_user_config, $(KERNEL_CONFIG), $(TARGET_BOARD_SPEC_CONFIG))
endif

$(TARGET_PREBUILT_KERNEL) : $(KERNEL_OUT) $(USER_CONFIG)
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=$(TARGET_KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) headers_install
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=$(TARGET_KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) -j${JOBS}
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=$(TARGET_KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) modules
	@-mkdir -p $(KERNEL_MODULES_OUT)
	@-find $(TARGET_OUT_INTERMEDIATES) -name *.ko | xargs -I{} cp {} $(KERNEL_MODULES_OUT)

$(KERNEL_USR_HEADERS) : $(KERNEL_OUT)
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=$(TARGET_KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) headers_install

kernelheader:
	mkdir -p $(KERNEL_OUT)
	$(MAKE) ARCH=$(TARGET_KERNEL_ARCH) -C kernel O=../$(KERNEL_OUT) headers_install

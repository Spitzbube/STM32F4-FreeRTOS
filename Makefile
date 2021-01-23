TARGET:=FreeRTOS
# TODO change to your ARM gcc toolchain path
TOOLCHAIN_ROOT:=~/opt/xPacks/arm-none-eabi-gcc/xpack-arm-none-eabi-gcc-9.2.1-1.1
TOOLCHAIN_PATH:=$(TOOLCHAIN_ROOT)/bin
TOOLCHAIN_PREFIX:=arm-none-eabi

# Optimization level, can be [0, 1, 2, 3, s].
OPTLVL:=1 #0
DBG:=#-g

FREERTOS:=$(CURDIR)/FreeRTOS
STARTUP:=$(CURDIR)/hardware
LINKER_SCRIPT:=$(CURDIR)/Utilities/stm32_flash.ld

INCLUDE=-I$(CURDIR)/hardware
INCLUDE+=-I$(FREERTOS)/include
INCLUDE+=-I$(FREERTOS)/portable/GCC/ARM_CM4F
INCLUDE+=-I$(CURDIR)/Libraries/CMSIS/Device/ST/STM32F4xx/Include
INCLUDE+=-I$(CURDIR)/Libraries/CMSIS/Include
INCLUDE+=-I$(CURDIR)/Libraries/STM32F4xx_StdPeriph_Driver/inc
INCLUDE+=-I$(CURDIR)/config

INCLUDE+=-I$(CURDIR)/Utilities/STM32_EVAL/Common
INCLUDE+=-I$(CURDIR)/Utilities/STM32_EVAL/STM3240_41_G_EVAL
INCLUDE+=-I$(CURDIR)/USB
INCLUDE+=-I$(CURDIR)/Libraries/STM32_USB_OTG_Driver/inc
INCLUDE+=-I$(CURDIR)/Libraries/STM32_USB_Device_Library/Core/inc

##INCLUDE+=-I$(CURDIR)/Libraries/STM32_USB_Device_Library/Class/hid/inc
##INCLUDE+=-I$(CURDIR)/USB/HID

INCLUDE+=-I$(CURDIR)/Libraries/STM32_USB_Device_Library/Class/cdc/inc
INCLUDE+=-I$(CURDIR)/USB/VCP


BUILD_DIR = $(CURDIR)/build
BIN_DIR = $(CURDIR)/binary

# vpath is used so object files are written to the current directory instead
# of the same directory as their source files
vpath %.c $(CURDIR)/Libraries/STM32F4xx_StdPeriph_Driver/src \
          $(CURDIR)/Libraries/syscall $(CURDIR)/hardware $(FREERTOS) \
          $(FREERTOS)/portable/MemMang $(FREERTOS)/portable/GCC/ARM_CM4F \
          $(CURDIR)/Libraries/STM32_USB_Device_Library/Core/src \
          $(CURDIR)/Libraries/STM32_USB_Device_Library/Class/cdc/src \
          $(CURDIR)/Libraries/STM32_USB_OTG_Driver/src \
          $(CURDIR)/USB \
          $(CURDIR)/USB/VCP

#          $(CURDIR)/USB/HID
#          $(CURDIR)/Libraries/STM32_USB_Device_Library/Class/hid/src 
          
vpath %.s $(STARTUP)
ASRC=startup_stm32f4xx.s

# Project Source Files
SRC+=stm32f4xx_it.c
SRC+=system_stm32f4xx.c
SRC+=main.c
SRC+=syscalls.c

SRC+=usbd_core.c
SRC+=usbd_ioreq.c
SRC+=usbd_req.c

##SRC+=usbd_hid_core.c
SRC+=usbd_cdc_core.c

SRC+=usb_dcd.c
SRC+=usb_dcd_int.c
SRC+=usb_core.c

SRC+=usb_bsp.c
SRC+=usbd_desc.c
SRC+=usbd_usr.c
SRC+=usbd_cdc_vcp.c

# FreeRTOS Source Files
SRC+=port.c
SRC+=list.c
SRC+=queue.c
SRC+=tasks.c
SRC+=event_groups.c
SRC+=timers.c
SRC+=heap_4.c

# Standard Peripheral Source Files
SRC+=misc.c
#SRC+=stm32f4xx_dcmi.c
#SRC+=stm32f4xx_hash.c
SRC+=stm32f4xx_rtc.c
#SRC+=stm32f4xx_adc.c
#SRC+=stm32f4xx_dma.c
#SRC+=stm32f4xx_hash_md5.c
#SRC+=stm32f4xx_sai.c
#SRC+=stm32f4xx_can.c
#SRC+=stm32f4xx_dma2d.c
#SRC+=stm32f4xx_hash_sha1.c
#SRC+=stm32f4xx_sdio.c
#SRC+=stm32f4xx_cec.c
#SRC+=stm32f4xx_dsi.c
#SRC+=stm32f4xx_i2c.c
#SRC+=stm32f4xx_spdifrx.c
#SRC+=stm32f4xx_crc.c
SRC+=stm32f4xx_exti.c
#SRC+=stm32f4xx_iwdg.c
SRC+=stm32f4xx_spi.c
#SRC+=stm32f4xx_cryp.c
#SRC+=stm32f4xx_flash.c
#SRC+=stm32f4xx_lptim.c
SRC+=stm32f4xx_syscfg.c
#SRC+=stm32f4xx_cryp_aes.c
#SRC+=stm32f4xx_flash_ramfunc.c
#SRC+=stm32f4xx_ltdc.c
#SRC+=stm32f4xx_tim.c
#SRC+=stm32f4xx_cryp_des.c
#SRC+=stm32f4xx_fmc.c
SRC+=stm32f4xx_pwr.c
SRC+=stm32f4xx_usart.c
#SRC+=stm32f4xx_cryp_tdes.c
#SRC+=stm32f4xx_fmpi2c.c
#SRC+=stm32f4xx_qspi.c
SRC+=stm32f4xx_wwdg.c
#SRC+=stm32f4xx_dac.c
#SRC+=stm32f4xx_fsmc.c
SRC+=stm32f4xx_rcc.c
#SRC+=stm32f4xx_dbgmcu.c
SRC+=stm32f4xx_gpio.c
#SRC+=stm32f4xx_rng.c

CDEFS=-DUSE_STDPERIPH_DRIVER
CDEFS+=-DSTM32F4XX
CDEFS+=-DSTM32F40_41xxx
CDEFS+=-DHSE_VALUE=8000000
CDEFS+=-D__FPU_PRESENT=1
CDEFS+=-D__FPU_USED=1
CDEFS+=-DARM_MATH_CM4

CDEFS+=-DUSE_STM324xG_EVAL
CDEFS+=-DUSE_USB_OTG_FS

MCUFLAGS=-mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant -finline-functions -Wdouble-promotion -std=gnu99
COMMONFLAGS=-O$(OPTLVL) $(DBG) -Wall -ffunction-sections -fdata-sections
CFLAGS=$(COMMONFLAGS) $(MCUFLAGS) $(INCLUDE) $(CDEFS)

LDLIBS=-lm -lc -lgcc
LDFLAGS=$(MCUFLAGS) -u _scanf_float -u _printf_float -fno-exceptions -Wl,--gc-sections,-T$(LINKER_SCRIPT),-Map,$(BIN_DIR)/$(TARGET).map

CC=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-gcc
LD=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-gcc
OBJCOPY=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-objcopy
AS=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-as
AR=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-ar
GDB=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-gdb

OBJ = $(SRC:%.c=$(BUILD_DIR)/%.o)

$(BUILD_DIR)/%.o: %.c
	@echo [CC] $(notdir $<)
	@$(CC) $(CFLAGS) $< -c -o $@

all: $(OBJ)
	@echo [AS] $(ASRC)
	@$(AS) -o $(ASRC:%.s=$(BUILD_DIR)/%.o) $(STARTUP)/$(ASRC)
	@echo [LD] $(TARGET).elf
	@$(CC) -o $(BIN_DIR)/$(TARGET).elf $(LDFLAGS) $(OBJ) $(ASRC:%.s=$(BUILD_DIR)/%.o) $(LDLIBS)
	@echo [HEX] $(TARGET).hex
	@$(OBJCOPY) -O ihex $(BIN_DIR)/$(TARGET).elf $(BIN_DIR)/$(TARGET).hex
	@echo [BIN] $(TARGET).bin
	@$(OBJCOPY) -O binary $(BIN_DIR)/$(TARGET).elf $(BIN_DIR)/$(TARGET).bin

.PHONY: clean

clean:
	@echo [RM] OBJ
	@rm -f $(OBJ)
	@rm -f $(ASRC:%.s=$(BUILD_DIR)/%.o)
	@echo [RM] BIN
	@rm -f $(BIN_DIR)/$(TARGET).elf
	@rm -f $(BIN_DIR)/$(TARGET).hex
	@rm -f $(BIN_DIR)/$(TARGET).bin

flash:
	@st-flash write $(BIN_DIR)/$(TARGET).bin 0x8000000

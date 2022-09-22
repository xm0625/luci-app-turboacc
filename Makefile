# Copyright (C) 2022 Lean <coolsnowwolf@gmail.com>
# Copyright (C) 2019-2022 ImmortalWrt.org
# Copyright (C) 2020-2022 lala-openwrt <https://github.com/AutoCONFIG/lala-openwrt>
#
# Welcome to my Github <https://github.com/AutoCONFIG>

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-turboacc
PKG_RELEASE:=$(COMMITCOUNT)

PKG_LICENSE:=GPL-3.0-only
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org> & Lean <coolsnowwolf@gmail.com> & LALA <1559272797@qq.com>

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_BBR_CCA \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_DRV

LUCI_TITLE:=LuCI support for Flow Offload / Shortcut-FE
LUCI_DEPENDS:=+PACKAGE_$(PKG_NAME)_INCLUDE_BBR_CCA:kmod-tcp-bbr \
	+PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING:kmod-ipt-offload \
	+PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE:kmod-fast-classifier \
	+PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM:kmod-shortcut-fe-cm \
	+PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_DRV:kmod-shortcut-fe-drv
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/config
config PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING
	bool "Include Flow Offload"
	default y if (TARGET_mediatek||TARGET_ramips)

config PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_DRV
	bool "Include Shortcut-FE for ECM"
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING=n
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM=n
	depends on (TARGET_ipq60xx||TARGET_ipq806x||TARGET_ipq807x)
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE_CM
	bool "Include Shortcut-FE ECM"
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING=n
	default y if !(TARGET_ipq60xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_rockchip)
	
config PACKAGE_$(PKG_NAME)_INCLUDE_SHORTCUT_FE
	bool "Include Shortcut-FE"
	depends on PACKAGE_$(PKG_NAME)_INCLUDE_OFFLOADING=n
	default y if TARGET_rockchip

config PACKAGE_$(PKG_NAME)_INCLUDE_BBR_CCA
	bool "Include BBR CCA"
	default y
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature

# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=daed-next
PKG_VERSION:=2024-01-12
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/daeuniverse/daed-revived-next.git
PKG_SOURCE_VERSION:=a5647d2947b415418f6c0ef8f137b3865700f82f
PKG_MIRROR_HASH:=7594f785e6e41139fe0d93bafc5371d12116adefb3307629d61273254ff21d09

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)/wing
PKG_BUILD_DEPENDS:=golang/host bpf-headers node/host node-yarn/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/daeuniverse/dae-wing
GO_PKG_LDFLAGS:= \
	-X '$(GO_PKG)/db.AppDescription=dae-wing is a integration solution of dae, API and UI.'
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/db.AppName=dae-wing \
	$(GO_PKG)/db.AppVersion=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/bpf.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/daed-next/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  URL:=https://github.com/daeuniverse/daed-revived-next
endef

define Package/daed-next
  $(call Package/daed-next/Default)
  TITLE:=daed-next is a backend of dae
  # You need enable KERNEL_DEBUG_INFO_BTF and KERNEL_BPF_EVENTS
  DEPENDS:=$(GO_ARCH_DEPENDS) $(BPF_DEPENDS) \
    +ca-bundle +kmod-sched-core +kmod-sched-bpf +kmod-xdp-sockets-diag \
    +node +v2ray-geoip +v2ray-geosite
endef

define Package/daed-next/description
  daed-next is a backend of dae, provides a method to bundle arbitrary
  frontend, dae and geodata into one binary.
endef

define Package/daed-next/conffiles
/etc/daed-next/wing.db
/etc/config/daed-next
endef

define Build/Prepare
	$(TAR) --strip-components=1 -C $(PKG_BUILD_DIR)/../ -xzf $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION).tar.gz
endef

DAE_CFLAGS:= \
	-O2 -Wall -Werror \
	-DMAX_MATCH_SET_LEN=64 \
	-I$(BPF_HEADERS_DIR)/tools/lib \
	-I$(BPF_HEADERS_DIR)/arch/$(BPF_KARCH)/include/asm/mach-generic

ifneq ($(CONFIG_USE_MUSL),)
  TARGET_CFLAGS += -D_LARGEFILE64_SOURCE
endif

define Build/Compile
	( \
		pushd $(PKG_BUILD_DIR) ; \
		pushd .. ; \
		yarn install ; \
		STANDALONE=1 yarn build ; \
		$(CP) .next/standalone out ; \
		$(CP) .next/static out/.next/ ; \
		$(CP) public out ; \
		$(STAGING_DIR_HOST)/bin/mksquashfs4 out daed-web.squashfs -comp xz ; \
		popd ; \
		$(MAKE) deps ; \
		$(GO_GENERAL_BUILD_CONFIG_VARS) \
		$(GO_PKG_BUILD_CONFIG_VARS) \
		$(GO_PKG_BUILD_VARS) \
		go generate ./... ; \
		cd dae-core ; \
		$(GO_GENERAL_BUILD_CONFIG_VARS) \
		$(GO_PKG_BUILD_CONFIG_VARS) \
		$(GO_PKG_BUILD_VARS) \
		BPF_CLANG="$(CLANG)" \
		BPF_STRIP_FLAG="-strip=$(LLVM_STRIP)" \
		BPF_CFLAGS="$(DAE_CFLAGS)" \
		BPF_TARGET="bpfel,bpfeb" \
		go generate control/control.go ; \
		popd ; \
		$(call GoPackage/Build/Compile) ; \
	)
endef

define Package/daed-next/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dae-wing $(1)/usr/bin/dae-wing

	$(INSTALL_DIR) $(1)/usr/share/daed-next
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/../daed-web.squashfs $(1)/usr/share/daed-next/daed-web.squashfs

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(CURDIR)/files/daed-next.config $(1)/etc/config/daed-next

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(CURDIR)/files/daed-next.init $(1)/etc/init.d/daed-next
endef

$(eval $(call GoBinPackage,daed-next))
$(eval $(call BuildPackage,daed-next))

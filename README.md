<h1 align="center">luci-app-daed-next</h1>
<p align="center">
  <img width="100" src="https://user-images.githubusercontent.com/16485166/261898124-7193042f-e162-43dc-9dcf-db02e24e748d.png" />
</p>
<p align="center">
  <b>A Linux high-performance transparent proxy solution based on eBPF.</b>
  <br />
  <b>https://github.com/daeuniverse/daed-revived-next</b>
</p>

-----------

## Build on OpenWrt Official 23.05/SNAPSHOT

### 1. Get Source

```bash
git clone https://github.com/sbwml/luci-app-daed-next package/daed-next
```

### 2. Install clang-13, refer to https://apt.llvm.org

```bash
apt-get update
apt-get install -y clang-13
```

### 3. Compile Options (Requirements for `DAED` to work)

- Enable eBPF support, add content to: `.config`
  ```
  CONFIG_DEVEL=y
  CONFIG_BPF_TOOLCHAIN_HOST=y
  # CONFIG_BPF_TOOLCHAIN_NONE is not set
  CONFIG_KERNEL_BPF_EVENTS=y
  CONFIG_KERNEL_CGROUP_BPF=y
  CONFIG_KERNEL_DEBUG_INFO=y
  CONFIG_KERNEL_DEBUG_INFO_BTF=y
  # CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set
  CONFIG_KERNEL_XDP_SOCKETS=y
  ```

### 4. Build luci-app-daed-next

```bash
make menuconfig # choose LUCI -> Applications -> luci-app-daed-next
make package/daed-next/luci-app-daed-next/compile V=s # build luci-app-daed-next
```

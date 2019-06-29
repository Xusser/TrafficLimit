# TrafficLimit

通过iptables对单个端口的TCP+UDP流量进行自动封禁/解除封禁操作

## 依赖命令

```shell
apt install bc -y
```

## 文件构成

- TafficCheck.sh 查询/检查端口流量情况,根据传入参数实现达量禁用功能
- AddCheck.sh 为端口添加流量检查
- DelCheck.sh 为端口关闭流量检查
- ResetTraffic.sh 为端口重置流量计数器


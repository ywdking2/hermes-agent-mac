# Hermes Agent - Mac Mini 本地部署

基于 [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) 部署在本地 Mac Mini (M4) 上的 AI 智能体，通过微信与用户交互。

## 架构

```
微信用户 <---> 腾讯 iLink Bot API <---> Hermes Gateway (Mac Mini) <---> Z.AI GLM-5.1 API
```

## 环境信息

| 项目 | 配置 |
|------|------|
| 硬件 | Mac Mini M4 |
| 系统 | macOS (Apple Silicon) |
| Python | 3.11.14 (venv) |
| Hermes | v0.9.0 |
| LLM 提供商 | Z.AI / GLM |
| 模型 | glm-5.1 |
| API 端点 | `https://api.z.ai/api/coding/paas/v4` (Coding Plan) |
| 消息平台 | 微信（个人微信） |

## 安装步骤

### 1. 克隆仓库

```bash
git clone --recurse-submodules https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
```

### 2. 创建 Python 虚拟环境并安装依赖

```bash
uv venv venv --python 3.11
source venv/bin/activate
uv pip install -e ".[all]"
uv pip install aiohttp cryptography qrcode
```

### 3. 配置环境变量

编辑 `~/.hermes/.env`：

```bash
GLM_API_KEY=你的z.ai API Key
GLM_BASE_URL=https://api.z.ai/api/coding/paas/v4

WEIXIN_ACCOUNT_ID=你的微信bot account id
WEIXIN_TOKEN=你的微信bot token
WEIXIN_BASE_URL=https://ilinkai.weixin.qq.com
WEIXIN_DM_POLICY=open
WEIXIN_ALLOW_ALL_USERS=true
WEIXIN_GROUP_POLICY=open
```

### 4. 选择模型

```bash
hermes model
# 选择 Z.AI / GLM -> GLM-5.1（或其他 Coding Plan 内模型）
```

Coding Lite 套餐支持的模型：GLM-5.1、GLM-5-Turbo、GLM-4.7、GLM-4.6、GLM-4.5-Air

### 5. 配置微信

```bash
hermes gateway setup
# 选择 Weixin / WeChat -> 扫码登录
```

## 启动与管理

### 启动网关（后台运行，SSH 断开不停止）

```bash
~/Documents/hermes-agent/start-gateway.sh
```

### 手动启动

```bash
cd /Users/wendiyang/Documents/hermes-agent
source venv/bin/activate
nohup python3 -u -m hermes_cli.main gateway run --replace \
  > ~/.hermes/logs/gateway.log \
  2> ~/.hermes/logs/gateway.error.log &
```

### 查看日志

```bash
tail -f ~/.hermes/logs/gateway.log        # 实时日志
tail -f ~/.hermes/logs/gateway.error.log  # 错误日志
```

### 停止网关

```bash
pkill -f "hermes_cli.main gateway"
```

### 诊断

```bash
hermes doctor   # 环境诊断
hermes version  # 版本信息
```

## 目录结构

```
~/Documents/hermes-agent/       # 项目代码
~/.hermes/                      # 运行时数据
├── .env                        # API Keys 和环境变量
├── auth.json                   # 认证状态
├── config.yaml                 # 配置文件
├── logs/                       # 日志
│   ├── gateway.log
│   └── gateway.error.log
├── memories/                   # Agent 持久记忆
├── sessions/                   # 会话记录
├── skills/                     # 自动学习的技能
└── SOUL.md                     # Agent 人格设定
```

## 注意事项

- Z.AI Coding Plan 需要使用 `https://api.z.ai/api/coding/paas/v4` 端点，不是通用 API 端点
- 微信连接使用长轮询，不需要公网 IP
- 通过 SSH 远程管理时，需用 `nohup` 方式后台启动，launchd 服务在非 GUI 会话下可能不工作
- 微信 session 过期后需重新运行 `hermes gateway setup` 扫码

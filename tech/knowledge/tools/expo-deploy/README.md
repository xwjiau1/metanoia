# Expo 云端构建 Skill

## 用途
用于 HYROS Fit 及其他 Expo/React Native 项目的 EAS 云端构建。

## 前置条件
- `EXPO_TOKEN` 已设置（通过 `source ~/.expo_token_env` 或手动 `export`）
- 项目目录包含 `eas.json`、`app.json`、`package.json`

## 构建流程

### 1. 确认 Token
```bash
if [ -z "$EXPO_TOKEN" ]; then
  echo "EXPO_TOKEN 未设置，先执行: source ~/.expo_token_env"
  exit 1
fi
```

### 2. 检查项目配置
```bash
cd <项目目录>
cat app.json  # 确认 version、slug、package
```

### 3. 版本更新（可选）
如需更新版本号，修改：
- `app.json` 中的 `version` 字段
- `package.json` 中的 `version` 字段
- 然后 `git commit`

### 4. 执行构建
```bash
cd <项目目录>
npx eas build --platform android --profile preview --non-interactive
```

构建完成后，EAS 会提供 APK 下载链接。

### 5. 查看构建状态
如果命令中断，用此链接查看状态：
```
https://expo.dev/accounts/jiawenoo9/projects/<slug>/builds/<build-id>
```

## 已配置项目

| 项目 | 路径 | Slug | 当前版本 |
|------|------|------|----------|
| HYROS Fit | /root/.openclaw/workspace/projects/hyros-fit/03-源码/src | hyros-fit | v4.0.0 |

## 注意事项
- Token 有效期有限，如失效需到 expo.dev/settings/access-tokens 重新生成
- `--profile preview` 输出 APK，用于测试
- `--profile production` 输出 AAB，用于 Google Play 上架
- 构建在 Expo 云端执行，本地只需上传代码，无需 Android SDK

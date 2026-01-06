# Testing Guide

このドキュメントでは、`render-mermaid-svg` GitHub Actionのローカルテスト方法について説明します。

## テスト概要

`act`を使用して、GitHub Actionsと同じ環境を再現したテストをローカルから行います。


### 前提条件

[act](https://github.com/nektos/act)

```bash
# macOS (Homebrew使用)
brew install act
```

### 実行方法

```bash
./scripts/test-local.sh
```

### actionsファイルについて

`.github/workflows/local-test.yml`は、actでのローカル実行用、テスト用のステップで構成されています。
GitHub上でCIとして実行する場合は、通常のworkflowとして別途設定してください。

# unit-testing
这个项目主要提供了django单元测试相关的pre-commit hooks工具,实现了在提交`git commit`时，执行下面hooks

## pre-commit配置

> 在本地.pre-commit-config.yaml 文件中追加下面配置，并修改。
> 注意不要复制`repos:`


**如果没有安装pre-commit**:
安装 pre-commit:
```bash
pip install pre-commit
```
设置pre-commit hooks:
```bash
pre-commit install
```

## hooks
实现在提交git commit时,执行下方配置的hooks
> 由于mac平台上的grep和linux平台上的grep使用有差别，所以使用shell调用各自平台的可执行文件进处理。
> 可执行文件使用dart语言编写，编译为mac和linux的可执行文件
### check-coverage
在指定容器中运行coverage检查django的项目的单元测试覆盖率。
```yaml
repos:

  - repo: https://github.com/jiangwenfan/pre-commit_tools.git
    # [修改] 更新到最新
    rev: v0.0.4
    hooks:
    - id: check-coverage
      name: Check Coverage
      # [修改] 容器名 容器内manage.py 覆盖率
      entry: .pre-commit-hooks/check_coverage.sh redk-BaseApplication manage.py 90
      language: script
      stages: [commit]
```
### generate_env_sample_file
从本地 `.env` 文件生成 `.env.sample`文件
```yaml
repos:

  - repo: https://github.com/jiangwenfan/pre-commit_tools.git
    # [修改] 更新到最新
    rev: v0.0.8
    hooks:
    - id: generate-sample-env-file
      name: 生成env配置文件
      description: node处理
      # 默认处理当前目录下的.env文件，也可以通过这样： --file="a/b/c/.env" 处理指定目录的.env文件
      entry: generate_sample_env
      language: node
      stages: [commit]
```

### generate_toml_sample_file
从本地 `xxx.toml` 文件生成 `xxx.toml.sample`文件
```yaml
repos:

  - repo: https://github.com/jiangwenfan/pre-commit_tools.git
    # [修改] 更新到最新
    rev: v0.0.8
    hooks:
    - id: generate-sample-toml-file
      # 默认使用.pre-commit-hooks.yaml中的name1,这里可以定义覆盖
      name: 从toml配置文件生成toml sample文件
      description: python处理
      # 显示日志 --verbose
      # 指定要处理toml文件 --file ./config.toml 默认是 config.toml
      entry: generate_sample_toml
      language: python
      # commit 阶段执行
      stages: [commit]
```
执行
```
pre-commit run --all-files
```
输出,本地多了一个`config.toml.sample`文件
```
(base) jason@jasonMacPro pre-test % pre-commit run --all-files
[INFO] Initializing environment for https://github.com/jiangwenfan/pre-commit_tools.git.
[INFO] Installing environment for https://github.com/jiangwenfan/pre-commit_tools.git.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
从toml配置文件生成toml sample文件........................................Passed
```
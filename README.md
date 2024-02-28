# unit-testing
这个项目主要提供了django单元测试相关的pre-commit hooks工具,实现了在提交`git commit`时，执行下面hooks

### pre-commit配置

> 在本地.pre-commit-config.yaml 文件中追加下面配置，并修改。
> 注意不要复制`repos:`

#### check-coverage
在指定容器中运行coverage检查django的项目的单元测试覆盖率。
```yaml
repos:

  - repo: https://github.com/jiangwenfan/unit-testing
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
#### generate_sample_file
实现在提交git commit时,
1. 从本地 `xxx.toml` 文件生成 `xxx.toml.sample`文件
2. 从本地 `.env` 文件生成 `.env.sample`文件


### 如果没有安装pre-commit:

安装 pre-commit:
```bash
pip install pre-commit
```
设置pre-commit hooks:
```bash
pre-commit install
```

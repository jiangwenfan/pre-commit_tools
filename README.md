# unit-testing
单元测试相关的pre-commit hooks


在指定容器中运行coverage检查django的项目的单元测试覆盖率

pre-commit配置
```yaml
repos:

  - repo: local
    hooks:
    - id: check-coverage
      name: Check Coverage
      # check command. 容器名 容器内manage.py 覆盖率
      entry: .pre-commit-hooks/check_coverage.sh redk-BaseApplication manage.py 90
      language: script
      stages: [commit]

```

如果没有安装pre-commit:

install pre-commit:
```bash
pip install pre-commit
```
设置pre-commit hooks:
```bash
pre-commit install
```

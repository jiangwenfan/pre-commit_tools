import argparse
from argparse import Namespace
import logging
import tomllib
import tomli_w


# 将value全部设置为空xxx
def _set_value_empty(data):
    for key, value in data.items():
        logging.info(f"key: {key}, value: {value}")
        # 如果value是str, 则设置为空字符串
        if isinstance(value, str):
            logging.info(f"{key}是str, value: {value}")
            data[key] = "str-xxx"
        elif isinstance(value, bool):
            logging.info(f"{key}是bool, value: {value}")
            data[key] = "bool-xxx"
        # 如果value是int, 则设置为0
        elif isinstance(value, int):
            logging.info(f"{key}是int, value: {value}")
            data[key] = "int-xxx"
        elif isinstance(value, float):
            logging.info(f"{key}是float, value: {value}")
            data[key] = "float-xxx"
        # 如果value是list, 则设置为空list
        elif isinstance(value, list):
            logging.info(f"{key}是list, value: {value}")
            data[key] = []
        # 如果value是dict, 则递归调用
        elif isinstance(value, dict):
            _set_value_empty(value)
        else:
            logging.info(f"{key}是其他, value: {value}")
            data[key] = "其他xxx"


def handle_toml_file(file_name: str):
    """读取 toml 文件内容，生成 toml.sample 文件"""
    logging.info(f"处理toml文件: {file_name}")

    # 读取文件内容
    with open(file_name, "rb") as f:
        data = tomllib.load(f)

    # 处理
    _set_value_empty(data)

    # 写回文件
    with open("config.toml.sample", "wb") as f:
        tomli_w.dump(data, f)
    print(data)


def main():
    parser = argparse.ArgumentParser(
        description="根据toml实际配置文件生成toml.sample文件"
    )

    # 添加2个可选参数
    parser.add_argument(
        "--file",
        type=str,
        default="config.toml",
        help="可选参数，要处理的toml配置文件，默认读取当前目录下的 config.toml 文件",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="可选参数，增加输出的详细程度，默认不输出日志",
    )

    # args: Namespace = parser.parse_args()
    args, unknown = parser.parse_known_args()

    if args.verbose:
        logging.basicConfig(level=logging.INFO)
    else:
        logging.basicConfig(level=logging.ERROR)

    handle_toml_file(args.file)


if __name__ == "__main__":
    main()

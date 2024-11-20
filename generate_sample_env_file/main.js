#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');


function handleEnvFile(envPath = ".env") {
    // 0. 解析.env文件所在的目录
    const envDir = path.dirname(envPath);
    // 拼接.env.sample文件路径
    envSamplePath = path.join(envDir, ".env.sample");

    // 1. 读取.env文件内容
    const envConfig = dotenv.parse(fs.readFileSync(envPath));

    // 2. 将.env的文件内容处理为xxx-xxx的形式
    let res = [];
    for (const [key, originValue] of Object.entries(envConfig)) {
        // 如果value可以转换为number,则sampleValue为number-xxx,否则为string-xxx
        sampleValue = Number(originValue) ? '000' : 'string-xxx';
        line = `${key}="${sampleValue}"`;
        res.push(line);
    }
    // 生成 env.sample 文件内容
    const sampleEnvConfig = res.join('\n');
    // console.log(sampleEnvConfig)

    // 3.写入 env.sample 文件
    fs.writeFileSync(envSamplePath, sampleEnvConfig);
    // console.debug(`${envSamplePath}文件已生成`);
}

function main() {
    // 获取命令行参数
    const args = process.argv.slice(2);

    const fileOption = args.find(item => item.startsWith("--file="));

    // 判断参数个数. 如果没有找到--file=xxx参数,则使用默认值
    if (fileOption) {
        const envPath = fileOption.split('=')[1];
        // console.log(`读取 ${envPath} 文件...`);
        handleEnvFile(envPath);
    } else {
        // console.log(`读取当前目录下的 .env 文件...`);
        handleEnvFile();
    }
}

main()
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

    // 判断参数个数. 
    // 只能0个参数，使用默认.env文件
    // 或者1个参数，使用指定的.env文件
    if (args.length > 1) {
        console.error("参数个数错误,只能0个参数或者1个参数,传递.env文件路径");
        process.exit(1);
    } else if (args.length == 1) {
        // console.log(`读取 ${args[0]} 文件...`);
        handleEnvFile(envPath = args[0]);
    } else {
        // console.log(`读取当前目录下的 .env 文件...`);
        handleEnvFile();
    }
}

main()
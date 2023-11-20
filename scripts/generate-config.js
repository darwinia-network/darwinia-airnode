#!/usr/bin/env node

const path = require('path');
const fs = require('fs');
const _binPath = __dirname;
const _workPath = path.resolve(_binPath, '../');


function networkContent(name) {
  const types = ['mainnet', 'testnet'];
  for (const type of types) {
    const filePath = path.resolve(_workPath, `networks/${type}/${name}.json`);
    if (!fs.existsSync(filePath)) {
      continue;
    }
    const content = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(content);
  }
}

function render(dest, chain) {
  dest['chains'].push(chain['chain']);
  dest['triggers']['rrp'].push(chain['rrp']);
  dest['triggers']['http'].push(chain['http']);
  dest['ois'].push(chain['ois']);
}

function handleConfig(chains) {
  const destTemplateConfigFile = path.resolve(_workPath, 'config.json.template');

  const rawDataDestTemplateConfig = fs.readFileSync(destTemplateConfigFile, 'utf8');
  const dataDestTemplateConfig = JSON.parse(rawDataDestTemplateConfig);
  for (const chain of chains) {
    const chainData = networkContent(chain);
    if (!chainData) {
      console.warn(`not found config for ${chain} `);
      continue;
    }
    render(dataDestTemplateConfig, chainData);
    console.log(`render ${chain}`);
  }
  return dataDestTemplateConfig;
}

function handleEnv(config) {
  const secretEnvPath = path.resolve(_workPath, 'secrets.env');
  if (!fs.existsSync(secretEnvPath)) {
    console.warn('missing secrets.env file');
    process.exit(1);
  }

  const dataSecretEnv = fs.readFileSync(secretEnvPath, 'utf8');
  const lines = dataSecretEnv.split('\n');
  let cloudProvider = 'local';
  for (const line of lines) {
    if (line.indexOf('CLOUD_PROVIDER') == -1) continue;
    const companion = line.split('=');
    const [_name, value] = companion;
    cloudProvider = value;
    break;
  }

  switch (cloudProvider) {
    case 'aws':
      delete config['nodeSettings']['cloudProvider']['projectId'];
      break;
    case 'local':
      delete config['nodeSettings']['cloudProvider']['projectId'];
      delete config['nodeSettings']['cloudProvider']['region'];
      delete config['nodeSettings']['cloudProvider']['disableConcurrencyReservations'];
      break;
  }
}


function main() {
  const argv = process.argv;
  const args = argv.splice(2, argv.length);
  const config = handleConfig(args);
  handleEnv(config);

  const destConfigFile = path.resolve(_workPath, 'config.json');
  const dataDestConfig = JSON.stringify(config, null, 2);
  fs.writeFileSync(destConfigFile, dataDestConfig);
  console.log('done');
}

main();



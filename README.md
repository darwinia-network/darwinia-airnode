# Darwinia Airnode

## How to use this config

### Prerequisites

1. Clone this repo and create your own `secrets.env` file. Please note that this file will contain your private information, do not make it public

2. Generate airnode mnemonic, and then fill the field `AIRNODE_WALLET_MNEMONIC` in secrets.env with this mnemonic

    ```shell
    npm install -g @api3/airnode-admin
    npx @api3/airnode-admin generate-airnode-mnemonic

    # Save the mnemonic & xpub
    ```

3. Choose an API provider, such as [Infura](https://app.infura.io/dashboard) or [Alchemy](https://dashboard.alchemy.com/), and then create an API key.
Here we need the Arbitrum mainnet and Arbitrum Goerli API. And then set it in `secrets.env`

## Deploy

### Deploy Cloud

```shell
./scripts/deploy-cloud.sh
```

### Remove Cloud

```shell
./scripts/remove-cloud.sh
```

### Deploy Local

```shell
./scripts/deploy-local.sh
```

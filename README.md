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

4. If you forgot to save your xpub address, you can generate it with this command

    ```shell
    npx @api3/airnode-admin derive-airnode-xpub \
    --airnode-mnemonic "cricket elephant ..."
    ```

## Deploy

### Install jq

For Ubuntu or Debian: `apt install jq`

### Deploy via GCP

Project folder

```shell
darwinia-airnode
├── config.json
├── gcp.json
├── secrets.env
└── scripts
```

1. First [create a GCP project➚](https://cloud.google.com/resource-manager/docs/creating-managing-projects) (or use an existing GCP project) where the Airnode will be deployed. Once the project is created, add the project ID to the [secrets.env](secrets.env.example) file.

2. Make sure you have billing enabled for your project. To do so, you will need to pair the project with your bank card, although no charges will be incurred since the resource usage fits well within the free tier limit.

3. In order for Airnode to deploy successfully, you need to enable the [App Engine Admin API➚](https://console.cloud.google.com/apis/library/appengine.googleapis.com) specifically for the project. After enabling it, wait a few minutes before deploying the Airnode for this change to take effect.

4. Create a new service account from the [IAM and admin > Service accounts➚](https://console.cloud.google.com/) menu. Grant this account access to the project by adding the role Owner during creation.

5. Once the new service account is created, click on it to bring up its management page. Select the KEYS tab and add a new access key of type JSON for this account. Download the key file and place in the root of the `/darwinia-airnode` project directory. Rename it gcp.json.

6. Set `CLOUD_PROVIDER=gcp` in secrets.env also update `region` and `projectId` fields.

7. Deploy

    ```shell
    ./scripts/deploy-cloud.sh
    ```

    Save the HTTP gateway URL, and we can test the airnode by it.

8. Save the receipt.json, this file is used to remove the Airnode.

### Deploy via AWS

Project Folder

```shell
darwinia-airnode
├── aws.env
├── config.json
├── secrets.env
└── scripts
```

1. Add the access credentials in `aws.env` from your AWS account. If you don't have an account watch this [video➚](https://www.youtube.com/watch?v=KngM5bfpttA) to create one.

    ```shell
    AWS_ACCESS_KEY_ID: Is ACCESS_KEY_ID in IAM.
    AWS_SECRET_ACCESS_KEY: Is SECRET_ACCESS_KEY in IAM.
    ```

2. Set `CLOUD_PROVIDER=aws` in secrets.env also update `region` field.

3. Deploy

    ```shell
    ./scripts/deploy-cloud.sh
    ```

    Save the HTTP gateway URL, and we can test the airnode by it.

4. Save the receipt.json, this file is used to remove the Airnode.

### Remove with receipt

When an Airnode was deployed using the deploy command, a receipt.json file was created. This file is used to remove the Airnode.

```shell
./scripts/remove-cloud.sh
```

### Deploy Local

1. Install Docker

2. Set CLOUD_PROVIDER=local in secrets.env

    ```shell
    ./scripts/deploy-local.sh
    ```

## Sponsor

### Install airnode-admin-cli

1. npm install npx
2. npm install @api3/airnode-admin
3. export PRIVATE_MNEMONIC="YOUR WALLET MNEMONIC"

### Sponsor requester

Please note that you need to run this command on each chain to sponsor different requester. Currently: Pangolin & ArbitrumGoerli
And this command will submit a transaction, the sponsor-mnemonic wallet should have some token to pay the extrinsic fee.

```shell
npx @api3/airnode-admin sponsor-requester \
 --provider-url <Network RPC> \
 --sponsor-mnemonic "${PRIVATE_MNEMONIC}" \
 --requester-address <REQUESTER CONTRACT ADDRESS> \ # Get from dapi: <https://github.com/darwinia-oracle-dao/airnode-dapi/blob/main/bin/addr.json>
 --airnode-rrp-address <RRP CONTRACT ADDRESS>   # Listed below. RRP Contract Addresses
```

> Requester address 0x1234... is now sponsored by 0x456...

### Derive sponsor wallet

```shell
npx @api3/airnode-admin derive-sponsor-wallet-address \
  --airnode-xpub <AIRNODE XPUB ADDRESS> \ # Refer to **Prerequisites** Part, Step 4
  --airnode-address <AIRNODE PUB ADDRESS> \
  --sponsor-address <SPONSOR PUB ADDRESS> # This is the public key corresponding to the mnemonic address you used in the previous step.
```

> Sponsor wallet address: 0x1234...

## RRP Contract Addresses

### Darwinia Network

Pangolin: `0x6084A81dB23169F8a7BB5fa67C8a78ff9abA9819`

### Other Networks

<https://docs.api3.org/reference/airnode/latest/>

Arbitrum Goerli: `0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd`

## Request to join dAPI

[New Application](https://github.com/darwinia-oracle-dao/airnode-dapi/issues/new?assignees=hujw77&labels=application&projects=&template=airnode_application.yml&title=%5BApplication%5D%3A+%3Ctitle%3E)

## Check

### Check API

1. Check Pangolin Message Root:

    ```bash
    curl -X POST -H 'Content-Type: application/json' http://localhost:3000/http-data/01234567-abcd-abcd-abcd-012345678abc/0x23e5743c946604a779a5181a1bf621076cd11687a1f21c8bc2fa483bd704b3ab -d '{"parameters": {}}'

    # Example Result: {"rawValue":{"jsonrpc":"2.0","result":"0x23f8521e1830f581a286fd08b2cbab9055fb904f8ee727d54cfedcf1905a3897","id":"1"},"encodedValue":"0x23f8521e1830f581a286fd08b2cbab9055fb904f8ee727d54cfedcf1905a3897","values":["0x23f8521e1830f581a286fd08b2cbab9055fb904f8ee727d54cfedcf1905a3897"]}
    ```

2. Check ArbitrumGoerli Message Root:

    ```bash
    curl -X POST -H 'Content-Type: application/json' http://localhost:3000/http-data/01234567-abcd-abcd-abcd-012345678abc/0xe7fe8a321e9c000326638d5187a650e3f9d0652f30a01ad9ae4a60327e6c5277 -d '{"parameters": {}}'

    # Example Result: {"rawValue":{"jsonrpc":"2.0","result":"0x23f8521e1830f581a286fd08b2cbab9055fb904f8ee727d54cfedcf1905a3897","id":"1"},"encodedValue":"0x23f8521e1830f581a286fd08b2cbab9055fb904f8ee727d54cfedcf1905a3897","values":["0x23f8521e1830f581a286fd08b2cbab9055fb904f8ee727d54cfedcf1905a3897"]}
    ```

### Check Sponsor

1. Check on Pangolin

    ```bash
    # Replace <SPONSOR_ADDRESS> with your sponsor address without '0x'. For example: 9F33a4809aA708d7a399fedBa514e0A0d15EfA85
    curl -fsS https://pangolin-rpc.darwinia.network/ -d '{"id":1,"jsonrpc":"2.0","method":"eth_call","params":[{"data":"0xa81e9f79000000000000000000000000<SPONSOR_ADDRESS>000000000000000000000000770713580e5c618a4d29d7e8c0d7604276b63832","from":"0x0f14341A7f464320319025540E8Fe48Ad0fe5aec","gas":"0x1312d00","to":"0x6084A81dB23169F8a7BB5fa67C8a78ff9abA9819"},"latest"]}' -H 'Content-Type: application/json'

    # Result should be: {"jsonrpc":"2.0","result":"0x0000000000000000000000000000000000000000000000000000000000000001","id":1}
    ```

2. Check on ArbitrumGoerli

    ```bash
    # Replace <SPONSOR_ADDRESS> with your sponsor address without '0x'. For example: 9F33a4809aA708d7a399fedBa514e0A0d15EfA85
    curl -fsS https://rpc.goerli.arbitrum.gateway.fm -d '{"id":1,"jsonrpc":"2.0","method":"eth_call","params":[{"data":"0xa81e9f79000000000000000000000000<SPONSOR_ADDRESS>000000000000000000000000a681492DBAd5a3999cFCE2d72196d5784dd08D0c","from":"0x0f14341A7f464320319025540E8Fe48Ad0fe5aec","gas":"0x1312d00","to":"0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd"},"latest"]}' -H 'Content-Type: application/json'
    
    # Result should be: {"jsonrpc":"2.0","result":"0x0000000000000000000000000000000000000000000000000000000000000001","id":1}
    ```

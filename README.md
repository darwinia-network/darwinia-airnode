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

3. (Temporarily disabled) Choose an API provider, such as [Infura](https://app.infura.io/dashboard) or [Alchemy](https://dashboard.alchemy.com/), and then create an API key.
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

## Request to join dAPI

[New Application](https://github.com/darwinia-oracle-dao/airnode-dapi/issues/new?assignees=hujw77&labels=application&projects=&template=airnode_application.yml&title=%5BApplication%5D%3A+%3Ctitle%3E)

## Check

### Check API

- Check Crab Message Root:

    ```bash
    curl -X POST -H 'Content-Type: application/json' http://localhost:3000/http-data/01234567-abcd-abcd-abcd-012345678abc/0x23e5743c946604a779a5181a1bf621076cd11687a1f21c8bc2fa483bd704b3ab -d '{"parameters": {}}'

    # Example Result: {"rawValue":{"jsonrpc":"2.0","result":"0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000027ae5ba08d7291c96c8cbddcc148bf48a6d68c7974b94356f53754ef6171d757","id":"1"},"encodedValue":"0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000027ae5ba08d7291c96c8cbddcc148bf48a6d68c7974b94356f53754ef6171d757","values":["0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000027ae5ba08d7291c96c8cbddcc148bf48a6d68c7974b94356f53754ef6171d757"]}
    ```

- Check Darwinia Message Root:

    ```bash
    curl -X POST -H 'Content-Type: application/json' http://localhost:3000/http-data/01234567-abcd-abcd-abcd-012345678abc/0x45189e2288f2d2e384c9e3be7c3c6cef65a553341ca8580e1ed3516725112bb4 -d '{"parameters": {}}'
    ```

- Check ArbitrumSepolia Message Root:

    ```bash
    curl -X POST -H 'Content-Type: application/json' http://localhost:3000/http-data/01234567-abcd-abcd-abcd-012345678abc/0xe7fe8a321e9c000326638d5187a650e3f9d0652f30a01ad9ae4a60327e6c5277 -d '{"parameters": {}}'

    # Example Result: {"rawValue":{"jsonrpc":"2.0","id":"1","result":"0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000027ae5ba08d7291c96c8cbddcc148bf48a6d68c7974b94356f53754ef6171d757"},"encodedValue":"0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000027ae5ba08d7291c96c8cbddcc148bf48a6d68c7974b94356f53754ef6171d757","values":["0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000027ae5ba08d7291c96c8cbddcc148bf48a6d68c7974b94356f53754ef6171d757"]}
    ```

- Check Arbitrum Message Root:

    ```bash
    curl -X POST -H 'Content-Type: application/json' http://localhost:3000/http-data/01234567-abcd-abcd-abcd-012345678abc/0x18905d41e909c79069d74843dc474d0809df62b5bc555ea272b0cc49ff3fa924 -d '{"parameters": {}}'
    ```

### Check Sponsor

1. Check on Crab

    ```bash
    # Replace <SPONSOR_ADDRESS> with your sponsor address without '0x'. For example: 9F33a4809aA708d7a399fedBa514e0A0d15EfA85
    curl -fsS https://darwiniacrab-rpc.dwellir.com -d '{"id":1,"jsonrpc":"2.0","method":"eth_call","params":[{"data":"0xa81e9f79000000000000000000000000<SPONSOR_ADDRESS>00000000000000000000000000000000007317c91F57D86A410934A490E62E1E","from":"0x0f14341A7f464320319025540E8Fe48Ad0fe5aec","gas":"0x1312d00","to":"0x6084A81dB23169F8a7BB5fa67C8a78ff9abA9819"},"latest"]}' -H 'Content-Type: application/json'

    # Result should be: {"jsonrpc":"2.0","result":"0x0000000000000000000000000000000000000000000000000000000000000001","id":1}

    ## examples
    curl -fsS https://darwiniacrab-rpc.dwellir.com -d '{"id":1,"jsonrpc":"2.0","method":"eth_call","params":[{"data":"0xa81e9f790000000000000000000000009F33a4809aA708d7a399fedBa514e0A0d15EfA8500000000000000000000000000000000007317c91F57D86A410934A490E62E1E","from":"0x0f14341A7f464320319025540E8Fe48Ad0fe5aec","gas":"0x1312d00","to":"0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd"},"latest"]}' -H 'Content-Type: application/json'
    ```

2. Check on ArbitrumSepolia

    ```bash
    # Replace <SPONSOR_ADDRESS> with your sponsor address without '0x'. For example: 9F33a4809aA708d7a399fedBa514e0A0d15EfA85
    curl -fsS https://sepolia-rollup.arbitrum.io/rpc -d '{"id":1,"jsonrpc":"2.0","method":"eth_call","params":[{"data":"0xa81e9f79000000000000000000000000<SPONSOR_ADDRESS>00000000000000000000000000000000007317c91F57D86A410934A490E62E1E","from":"0x0f14341A7f464320319025540E8Fe48Ad0fe5aec","gas":"0x1312d00","to":"0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd"},"latest"]}' -H 'Content-Type: application/json'

    # Result should be: {"jsonrpc":"2.0","result":"0x0000000000000000000000000000000000000000000000000000000000000001","id":1}

    ## examples
    curl -fsS https://sepolia-rollup.arbitrum.io/rpc -d '{"id":1,"jsonrpc":"2.0","method":"eth_call","params":[{"data":"0xa81e9f790000000000000000000000009F33a4809aA708d7a399fedBa514e0A0d15EfA8500000000000000000000000000000000007317c91F57D86A410934A490E62E1E","from":"0x0f14341A7f464320319025540E8Fe48Ad0fe5aec","gas":"0x1312d00","to":"0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd"},"latest"]}' -H 'Content-Type: application/json'
    ```

## How to upgrade?

```bash
cd <Your config directory>
git checkout main
git pull
./scripts/deploy-local.sh  # The script you used before
```

## Sponsor (Optional)

### Install airnode-admin-cli

1. npm install npx
2. npm install @api3/airnode-admin
3. export PRIVATE_MNEMONIC="YOUR WALLET MNEMONIC"

### Sponsor requester

Please note that you need to run this command **on each chain** to sponsor different requester. Currently: Crab & ArbitrumSepolia.

And this command will submit a transaction, the sponsor-mnemonic wallet should have some token to pay the extrinsic fee.

```shell
npx @api3/airnode-admin sponsor-requester \
 --provider-url <Network RPC> \
 --sponsor-mnemonic "${PRIVATE_MNEMONIC}" \
 --requester-address <REQUESTER CONTRACT ADDRESS> \ # Get from dapi: <https://github.com/darwinia-oracle-dao/airnode-dapi/blob/main/bin/addr.json>
 --airnode-rrp-address <RRP CONTRACT ADDRESS>   # Listed below. RRP Contract Addresses

## examples
npx @api3/airnode-admin sponsor-requester \
 --providerUrl https://sepolia-rollup.arbitrum.io/rpc \
 --sponsor-mnemonic "${PRIVATE_MNEMONIC}" \
 --requester-address 0x00000000007317c91F57D86A410934A490E62E1E \
 --airnode-rrp-address 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd

npx @api3/airnode-admin sponsor-requester \
 --providerUrl https://darwiniacrab-rpc.dwellir.com \
 --sponsor-mnemonic "${PRIVATE_MNEMONIC}" \
 --requester-address 0x00000000007317c91F57D86A410934A490E62E1E \
 --airnode-rrp-address 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd
```

> Requester address 0x1234... is now sponsored by 0x456...

### Derive sponsor wallet

```shell
npx @api3/airnode-admin derive-sponsor-wallet-address \
  --airnode-xpub <AIRNODE XPUB ADDRESS> \ # Refer to **Prerequisites** Part, Step 4
  --airnode-address <AIRNODE PUB ADDRESS> \
  --sponsor-address <SPONSOR PUB ADDRESS> # This is the public key corresponding to the mnemonic address you used in the previous step.

## examples
npx @api3/airnode-admin derive-sponsor-wallet-address \
  --airnode-xpub xpub6DWQQABWBAU9NrbC9K965k1RsmLRkVaiTmU7rkhjsB6x8ExvuwxJW883j7uwVSY6ZEsR6jsVcZ9FF3KQDnE4s6sX6FWm3ZhbTSjzwpDcSSC \
  --airnode-address 0x1F7A2204b2c255AE6501eeCE29051315ca0aefa4 \
  --sponsor-address 0x9F33a4809aA708d7a399fedBa514e0A0d15EfA85
```

> Sponsor wallet address: 0x1234...

### Request withdrawal

```shell
## examples https://docs.api3.org/reference/airnode/latest/packages/admin-cli.html#request-withdrawal
npx @api3/airnode-admin request-withdrawal \
  --provider-url https://darwiniacrab-rpc.dwellir.com \
  --sponsor-mnemonic "${PRIVATE_MNEMONIC}" \
  --airnode-address 0x1F7A2204b2c255AE6501eeCE29051315ca0aefa4 \
  --airnode-rrp-address 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd \
  --sponsor-wallet-address 0x9674dc5e867014Ba91E6d53753BcA5D2abcFF9E3

npx @api3/airnode-admin request-withdrawal \
  --provider-url https://sepolia-rollup.arbitrum.io/rpc \
  --sponsor-mnemonic "${PRIVATE_MNEMONIC}" \
  --airnode-address 0x1F7A2204b2c255AE6501eeCE29051315ca0aefa4 \
  --airnode-rrp-address 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd \
  --sponsor-wallet-address 0x9674dc5e867014Ba91E6d53753BcA5D2abcFF9E3
```

## Develop

### Derive endpoint id

```bash
npx @api3/airnode-admin derive-endpoint-id \
  --ois-title "Crab Message Root" \
  --endpoint-name "CrabMessageRoot"

npx @api3/airnode-admin derive-endpoint-id \
  --ois-title "Arbitrum Sepolia Message Root" \
  --endpoint-name "ArbitrumSepoliaMessageRoot"
```

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
    npx @api3/airnode-admin derive-airnode-address \
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

```shell
npx @api3/airnode-admin sponsor-requester \
 --provider-url <Network RPC> \
 --sponsor-mnemonic "${PRIVATE_MNEMONIC}" \
 --requester-address <REQUESTER CONTRACT ADDRESS> \
 --airnode-rrp-address <RRP CONTRACT ADDRESS>
```

> Requester address 0x1234... is now sponsored by 0x456...

### Derive sponsor wallet

```shell
npx @api3/airnode-admin derive-sponsor-wallet-address \
  --airnode-xpub <AIRNODE XPUB ADDRESS> \
  --airnode-address <AIRNODE PUB ADDRESS> \
  --sponsor-address <SPONSOR PUB ADDRESS>
```

> Sponsor wallet address: 0x1234...

## RRP Contract Addresses

### Darwinia Network

Pangolin: `0x6084A81dB23169F8a7BB5fa67C8a78ff9abA9819`

### Other Networks

<https://docs.api3.org/reference/airnode/latest/>

## Request to join dAPI

[New Application](https://github.com/darwinia-oracle-dao/airnode-dapi/issues/new?assignees=hujw77&labels=application&projects=&template=airnode_application.yml&title=%5BApplication%5D%3A+%3Ctitle%3E)

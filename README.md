
<p align="center">
  <a href="https://lpthong90.dev/rails-ethereum-tx-explorer/">
    <img src="/assets/images/image_2.png" alt="Rails Ethereum Explorer">
  </a>
  
  <br>
  <em>Using Ruby on Rails to demo a simple version of <a href="https://etherscan.io/" target="_blank">Etherscan</a>.</em>
</p>
<!--more-->

---

**Documentation**: <a href="https://lpthong90.dev/rails-ethereum-tx-explorer" target="_blank">https://lpthong90.dev/rails-ethereum-tx-explorer</a>

**Source  Code**: <a href="https://github.com/lpthong90/rails-ethereum-tx-explorer" target="_blank">https://github.com/lpthong90/rails-ethereum-tx-explorer</a>

---

# Features
- List recent blocks, and recent transactions.
- View a block, a transaction, and a address.
- Search:
  - Block by number.
  - Transaction by hash.
  - Address by address.

# Related Services
- Redis => Use for caching and websockets
- [Alchemy](https://www.alchemy.com/) => Get `API_KEY` to query blocks, transactions, addresses.

# Environment Variables
```
CACHE_URL: redis://localhost:6379/1
REDIS_URL: redis://localhost:6379/1
ALCHEMY_URL: https://eth-mainnet.g.alchemy.com/v2/<API_KEY>
ALCHEMY_WEBSOCKET_URL: wss://eth-mainnet.g.alchemy.com/v2/<API_KEY>
```

# Run
``` bash
> bundle install
> ./bin/dev
```

# Screenshots

Home page:
<img src="assets/images/screenshots/home.png" alt="Home">

View recent blocks:
<img src="assets/images/screenshots/blocks.png" alt="Blocks">

View block by hash or number:
<img src="assets/images/screenshots/block.png" alt="Block">

View recent transactions:
<img src="assets/images/screenshots/transactions.png" alt="Transactions">

View transaction by hash:
<img src="assets/images/screenshots/transaction.png" alt="Transaction">

View address by hash:
<img src="assets/images/screenshots/address.png" alt="Address">

# Video demo:

<p align="center">
    <iframe width="800" height="450" src="https://www.youtube.com/embed/si-zVREI_jw?si=9hBeEZqzt74KSXV9" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</p>

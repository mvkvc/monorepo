---
title: Architecture
---

# architecture

- Site
  - Landing page
  - Python for now but can be redone in JS
  - Add blog in the future

- Apps
  - ID
    - Backed
      - Using built in email auth, want verification
      - Want something out of the box with bias to Python
      - Supposed to be transactional experience
    - Frontend
      - JS frontend only option with DRF backend
      - Transactions
  - Escrows
    - Main user facing app
    - Built in Elixir for user experience
    - Realtime events with PubSub

- Services
  - Chain
    - Contains private key to make transactions on-chain
    - Isolated service with private network for security
    - Ensure that only specific transactions can be made
    - Used
      - ID
        - Add approval to mint
        - Anything else?
  - Contracts
    - Contains all contracts code and tests
    - Used
      - ID
        - NFT contract
      - Escrow
        - Escrow contract
        - Invoice contract
        - Other contracts?
          - Subscription
          - Auction
  - Events
    - Track all events on chain and store in DB
    - Apps can subscribe to events
    - Used
      - ID
        - Track minting events
        - Track transfer events
      - Escrow
        - Track escrow events at all stages
        - Track invoice events
  - IPFS
    - Add and retrieve files from IPFS
    - Validate data in and out
    - Potentially validate schema passed in

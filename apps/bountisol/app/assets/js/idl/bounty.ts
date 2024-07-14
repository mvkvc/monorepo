export type Bounty = {
  "version": "0.1.0",
  "name": "bounty",
  "instructions": [
    {
      "name": "create",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "admin",
          "type": "publicKey"
        }
      ]
    },
    {
      "name": "assign",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "worker",
          "type": "publicKey"
        }
      ]
    },
    {
      "name": "fund",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payerTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    },
    {
      "name": "release",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "worker",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "workerTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    },
    {
      "name": "arbitrate",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "creator",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "creatorTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "worker",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "workerTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    },
    {
      "name": "reclaim",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "creator",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "creatorTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    }
  ],
  "accounts": [
    {
      "name": "bounty",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "bump",
            "type": "u8"
          },
          {
            "name": "assets",
            "type": {
              "vec": "publicKey"
            }
          },
          {
            "name": "deadlineWork",
            "type": "u64"
          },
          {
            "name": "deadlineDispute",
            "type": "u64"
          },
          {
            "name": "admin",
            "type": "publicKey"
          },
          {
            "name": "creator",
            "type": "publicKey"
          },
          {
            "name": "workers",
            "type": {
              "vec": "publicKey"
            }
          }
        ]
      }
    }
  ],
  "events": [
    {
      "name": "BountyCreated",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "bump",
          "type": "u8",
          "index": false
        },
        {
          "name": "deadlineWork",
          "type": "u64",
          "index": false
        },
        {
          "name": "deadlineDispute",
          "type": "u64",
          "index": false
        },
        {
          "name": "admin",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "creator",
          "type": "publicKey",
          "index": false
        }
      ]
    },
    {
      "name": "BountyAssigned",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "worker",
          "type": "publicKey",
          "index": false
        }
      ]
    },
    {
      "name": "BountyFunded",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "from",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    },
    {
      "name": "BountyReleased",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "to",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    },
    {
      "name": "BountyArbitrated",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "to",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    },
    {
      "name": "BountyReclaimed",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "to",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    }
  ],
  "errors": [
    {
      "code": 6000,
      "name": "InvalidAsset",
      "msg": "This asset does not exist in bounty."
    },
    {
      "code": 6001,
      "name": "DuplicateWorker",
      "msg": "This worker has already been assigned."
    },
    {
      "code": 6002,
      "name": "BountyNotExpired",
      "msg": "This bounty period has not expired yet."
    },
    {
      "code": 6003,
      "name": "ArbitrationNotExpired",
      "msg": "This arbitration period has not expired yet."
    }
  ]
};

export const IDL: Bounty = {
  "version": "0.1.0",
  "name": "bounty",
  "instructions": [
    {
      "name": "create",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "admin",
          "type": "publicKey"
        }
      ]
    },
    {
      "name": "assign",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "worker",
          "type": "publicKey"
        }
      ]
    },
    {
      "name": "fund",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payerTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    },
    {
      "name": "release",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "worker",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "workerTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    },
    {
      "name": "arbitrate",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "creator",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "creatorTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "worker",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "workerTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    },
    {
      "name": "reclaim",
      "accounts": [
        {
          "name": "bounty",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "bountyTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "creator",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "creatorTokenAccount",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "amount",
          "type": "u64"
        }
      ]
    }
  ],
  "accounts": [
    {
      "name": "bounty",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "bump",
            "type": "u8"
          },
          {
            "name": "assets",
            "type": {
              "vec": "publicKey"
            }
          },
          {
            "name": "deadlineWork",
            "type": "u64"
          },
          {
            "name": "deadlineDispute",
            "type": "u64"
          },
          {
            "name": "admin",
            "type": "publicKey"
          },
          {
            "name": "creator",
            "type": "publicKey"
          },
          {
            "name": "workers",
            "type": {
              "vec": "publicKey"
            }
          }
        ]
      }
    }
  ],
  "events": [
    {
      "name": "BountyCreated",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "bump",
          "type": "u8",
          "index": false
        },
        {
          "name": "deadlineWork",
          "type": "u64",
          "index": false
        },
        {
          "name": "deadlineDispute",
          "type": "u64",
          "index": false
        },
        {
          "name": "admin",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "creator",
          "type": "publicKey",
          "index": false
        }
      ]
    },
    {
      "name": "BountyAssigned",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "worker",
          "type": "publicKey",
          "index": false
        }
      ]
    },
    {
      "name": "BountyFunded",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "from",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    },
    {
      "name": "BountyReleased",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "to",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    },
    {
      "name": "BountyArbitrated",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "to",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    },
    {
      "name": "BountyReclaimed",
      "fields": [
        {
          "name": "address",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "to",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "token",
          "type": "publicKey",
          "index": false
        },
        {
          "name": "amount",
          "type": "u64",
          "index": false
        }
      ]
    }
  ],
  "errors": [
    {
      "code": 6000,
      "name": "InvalidAsset",
      "msg": "This asset does not exist in bounty."
    },
    {
      "code": 6001,
      "name": "DuplicateWorker",
      "msg": "This worker has already been assigned."
    },
    {
      "code": 6002,
      "name": "BountyNotExpired",
      "msg": "This bounty period has not expired yet."
    },
    {
      "code": 6003,
      "name": "ArbitrationNotExpired",
      "msg": "This arbitration period has not expired yet."
    }
  ]
};

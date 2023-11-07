---
title: spec_id
---

# spec_id

Outline the necessary methods for the ID smart contracts

Interfaces:

- ERC-165
  - functions
    - supportsInterface(bytes4 interfaceID): bool
- ERC-721
  - events
    - Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId)
    - Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId)
    - ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved)
  - functions
    - balanceOf(address _owner): uint256
    - ownerOf(uint256 _tokenId): address
    - safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data)payable
    - safeTransferFrom(address _from, address _to, uint256 _tokenId) payable
    - transferFrom(address _from, address _to, uint256 _tokenId) payable
    - approve(address _approved, uint256 _tokenId) payable
    - setApprovalForAll(address _operator, bool _approved)
    - getApproved(uint256 _tokenId): address)
    - isApprovedForAll(address _owner, address _operator): bool
- ERC721Metadata
  - functions
    - name() external view returns (string _name)
    - symbol() external view returns (string _symbol)
    - tokenURI(uint256 _tokenId) external view returns (string)
      - Must link to something that implements the JSON schema
      - {"title": "Asset Metadata",
    "type": "object",
    "properties": {
        "name": {
            "type": "string",
            "description": "Identifies the asset to which this NFT represents"
        },
        "description": {
            "type": "string",
            "description": "Describes the asset to which this NFT represents"
        },
        "image": {
            "type": "string",
            "description": "A URI pointing to a resource with mime type image/* representing the asset to which this NFT represents. Consider making any images at a width between 320 and 1080 pixels and aspect ratio between 1.91:1 and 4:5 inclusive."
        }
    }
}
- ERC721Enumerable
  - functions
    - function totalSupply() external view returns (uint256)
    - function tokenByIndex(uint256 _index) external view returns (uint256);
    - function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);

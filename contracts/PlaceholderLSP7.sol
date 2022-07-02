// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/LSP7DigitalAsset.sol";

contract PlaceholderLSP7 is LSP7DigitalAsset {

  constructor(string memory _name, string memory _symbol) LSP7DigitalAsset(_name, _symbol, msg.sender, true) {

  }

}
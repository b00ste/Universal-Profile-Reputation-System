// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/ILSP7DigitalAsset.sol";
import "./SymbolAward.sol";

/**
 * @title UniversalProfileReputationSystem
 * @author B00ste
 * @custom:version 0.1
 */
contract UniversalProfileReputationSystem {

  // Defining the address set.
  using EnumerableSet for EnumerableSet.AddressSet;

  // --- ATTRIBUTES

  /**
   * @notice Instance of the token, whoose holders can give symbols.
   */
  ILSP7DigitalAsset private mustHoldToken;

  /**
   * @notice Ctreating 5 instances of symbol tokens to be awarded as reputation.
   */
  SymbolAward symbol1;
  SymbolAward symbol2;
  SymbolAward symbol3;
  SymbolAward symbol4;
  SymbolAward symbol5;

  /**
   * @notice This array holds the 5 symbols that can be given to an Universal Profile.
   */
  SymbolAward[5] private symbols = [symbol1, symbol2, symbol3, symbol4, symbol5];

  /**
   * @notice The constructor saves a instance of the token at a certain address and creates 5 symbol tokens that will be awarded further.
   */
  constructor(address LSP7Address) {
    mustHoldToken = ILSP7DigitalAsset(LSP7Address);
    symbol2 = new SymbolAward(LSP7Address, unicode"👎", unicode"👎", msg.sender, true);
    symbol1 = new SymbolAward(LSP7Address, unicode"😡", unicode"😡", msg.sender, true);
    symbol3 = new SymbolAward(LSP7Address, unicode"👍", unicode"👍", msg.sender, true);
    symbol4 = new SymbolAward(LSP7Address, unicode"👏", unicode"👏", msg.sender, true);
    symbol5 = new SymbolAward(LSP7Address, unicode"💚", unicode"💚", msg.sender, true);
  }

  // --- MODIFIERS

  /**
   * @notice Verifies that the given number is 0, 1, 2, 3 or 4.
   */
  modifier symbolNumberExists(uint number) {
    require(
      number >= 0 && number <= 4,
      "The provided number has no symbol to represent."
    );
    _;
  }

  // --- GETTERS & SETTERS

  /**
   * @notice Getter for the array of symbols.
   */
  function getSymbols() external view returns(SymbolAward[5] memory) {
    return symbols;
  }

  /**
   * @notice Increases the number of symbols of the same type given.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose number of symbols of the same type is increased.
   * @param awardedUniversalProfileAddress The address of the Universal profile that will be awarded a Symbol reputation token.
   * @param symbolNumber The index number of the symbol.
   */
  function _awardSymbol(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint symbolNumber
  ) private {
    symbols[symbolNumber].mint(universalProfileAddress, awardedUniversalProfileAddress, 1, true, "");
  }

  /**
   * @notice Getter for the number of symbols of the same type given.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose number of the same type symbol we will get.
   * @param symbolNumber The index number of the symbol.
   */
  function getNumberOfSymbolsRecieved(address universalProfileAddress, uint symbolNumber) external view returns(uint256) {
    return symbols[symbolNumber].balanceOf(universalProfileAddress);
  }

  // --- GENERAL METHODS

  /**
   * @notice Award a symbol to a Universal Profile.
   *
   * @param universalProfileAddress The address of the Universal Profile that awards the symbol.
   * @param awardedUniversalProfileAddress The address of the Universal Profile that will recieve the symbol.
   * @param symbolNumber The index number of the symbol.
   */
  function awardSymbol(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint symbolNumber
  )
    external
    symbolNumberExists(symbolNumber)
  {
    _awardSymbol(universalProfileAddress, awardedUniversalProfileAddress, symbolNumber);
  }

}
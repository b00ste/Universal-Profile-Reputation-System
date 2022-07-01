// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/ILSP7DigitalAsset.sol";

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
   * @notice This attribute holds the 5 symbols that can be given to an Universal Profile.
   */
  bytes32[5] private symbols = [bytes32("U+1F621"), bytes32("U+1F44E"), bytes32("U+1F44D"), bytes32("U+1F44F"), bytes32("U+1F49A")];
 
  /**
   * @notice This attribute stores a number of eact symbol that were given to an Universal Profile.
   */
  mapping (address => mapping (bytes32 => uint256)) private numberOfSymbolsRecieved;
 
  /**
   * @notice This attribute stores the timestamp of the last awarded symbol.
   */
  mapping (address => uint) private lastTimeSymbolWasGiven;

  /**
   * @notice Instance of the token, whoose holders can give symbols.
   */
  ILSP7DigitalAsset private token;

  /**
   * @notice The constructor a instance of the token at a certain address.
   */
  constructor(address LSP7Address) {
    token = ILSP7DigitalAsset(LSP7Address);
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

  /**
   * @notice Verifies that the last awarded symbol timestamp is older than 24h.
   */
  modifier symbolGiven24hAgo(address universalProfileAddress) {
    require(
      lastTimeSymbolWasGiven[universalProfileAddress] + 1 days <= block.timestamp,
      "Universal Profile has given a symbol less than 1 day ago."
    );
    _;
  }

  /**
   * @notice Verifies that the address owns the `token`.
   */
  modifier ownsToken(address universalProfileAddress) {
    require(
      token.balanceOf(universalProfileAddress) >= 1,
      "Universal Profile doesn't hold any tokens."
    );
    _;
  }

  // --- GETTERS & SETTERS

  /**
   * @notice Getter for the array of symbols.
   */
  function getSymbols() external view returns(bytes32[5] memory) {
    return symbols;
  }

  /**
   * @notice Increases the number of symbols of the same type given.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose number of symbols of the same type is increased.
   * @param symbolNumber The index number of the symbol.
   */
  function increaseNumberOfSymbolsRecieved(address universalProfileAddress, uint symbolNumber) private {
    numberOfSymbolsRecieved[universalProfileAddress][symbols[symbolNumber]] ++;
  }

  /**
   * @notice Getter for the number of symbols of the same type given.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose number of the same type symbol we will get.
   * @param symbolNumber The index number of the symbol.
   */
  function getNumberOfSymbolsRecieved(address universalProfileAddress, uint symbolNumber) external view returns(uint256) {
    return numberOfSymbolsRecieved[universalProfileAddress][symbols[symbolNumber]];
  }

  /**
   * @notice Update the latest awarded symbol timestamp.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose last awarded symbol timestamp is updated.
   */
  function updateLastTime(address universalProfileAddress) private {
    lastTimeSymbolWasGiven[universalProfileAddress] = block.timestamp;
  }

  /**
   * @notice Getter of the last awarded symbol timestamp.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose last awarded symbol timestam we are getting.
   */
  function getLastTime(address universalProfileAddress) external view returns(uint) {
    return lastTimeSymbolWasGiven[universalProfileAddress];
  }

  // --- GENERAL METHODS

  /**
   * @notice Award a symbol to a Universal Profile.
   *
   * @param universalProfileAddress The address of the Universal Profile that awards the symbol.
   * @param winnerOfTheSymbol The address of the Universal Profile that will recieve the symbol.
   * @param symbolNumber The index number of the symbol.
   */
  function awardSymbol(
    address universalProfileAddress,
    address winnerOfTheSymbol,
    uint symbolNumber
  )
    external
    ownsToken(universalProfileAddress)
    symbolNumberExists(symbolNumber)
    symbolGiven24hAgo(universalProfileAddress)
  {
    increaseNumberOfSymbolsRecieved(winnerOfTheSymbol, symbolNumber);
    updateLastTime(universalProfileAddress);
  }

}
// SPDX-tokenFactionLicense-Identifier: UNLICENSED

pragma solidity ^0.8.12;

interface IRem64 {
    //String No Space
    function getFactionName(uint256 key) external view returns (string memory);

    // INT index
    function getFaction(uint256 tokenId) external view returns (uint256);

    //Human Readable
    function getFactionString(uint256 key)
        external
        view
        returns (string memory);
}

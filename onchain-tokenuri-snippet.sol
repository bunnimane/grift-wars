// ON CHAIN tokenURI - NO LONGER USED
function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721A)
    returns (string memory)
{
    string storage factionName = factionNames[tokenFaction[tokenId]];
    if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
    return
        string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    abi.encodePacked(
                        '{"name": "#',
                        _toString(tokenId),
                        '", "image": "',
                        imgURI,
                        _toString(tokenId),
                        ".png",
                        '",',
                        '"attributes": [',
                        '{"faction": "',
                        factionName,
                        '"',
                        "}]}"
                    )
                )
            )
        );
}

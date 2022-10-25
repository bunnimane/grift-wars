
START ANVIL:
anvil --chain-id 6969

DEPLOY TO ANVIL:
forge create --private-key=4d338b445d9147c3eb7c7ca971e392d4582c480e02802e099f61359e19e1bbb6 src/Lyra.sol:Lyra

MINT: 
cast send <contract>  "mint(uint256)" 3 --rpc-url http://127.0.0.1:8545 --private-key 4d338b445d9147c3eb7c7ca971e392d4582c480e02802e099f61359e19e1bbb6 --value 0.003ether


TOKEN URI:

cast call <contract>  "tokenURI(uint256)(string)" 1 --rpc-url http://127.0.0.1:8545

TOKENS OF OWNER: 

cast call <contract>  "tokensOfOwner(address)(uint256[])" 0xc309BDa59ac46c892C4def6F12bF394e58755351  --rpc-url http://127.0.0.1:8545

GOERLI RPC URL:
https://goerli.infura.io/v3/1f3a2b3b6eaf41c495878c23fa8221dd

DEPLOY TO GOERLI:
forge create --rpc-url https://goerli.infura.io/v3/1f3a2b3b6eaf41c495878c23fa8221dd  --private-key 4d338b445d9147c3eb7c7ca971e392d4582c480e02802e099f61359e19e1bbb6  src/Lyra.sol:Lyra     --etherscan-api-key BUVEKM57IBHU931F3NRQ7R5Z2R55AGMESG --verify

0xbC419F8b17d89F1961480c19cA6B5A130d919952

VERIFY ON GOERLI IF ABOVE FAILED:

forge verify-contract --chain-id 5 --watch  --compiler-version v0.8.17+commit.8df45f5f <contract addy>  src/Lyra.sol:Lyra BUVEKM57IBHU931F3NRQ7R5Z2R55AGMESG

MINT GOERLI:

cast send 0xbC419F8b17d89F1961480c19cA6B5A130d919952  "mint(uint256)" 3 --rpc-url https://goerli.infura.io/v3/1f3a2b3b6eaf41c495878c23fa8221dd --private-key 4d338b445d9147c3eb7c7ca971e392d4582c480e02802e099f61359e19e1bbb6 --value 0.003ether
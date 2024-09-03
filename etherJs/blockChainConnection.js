const ethers = require("ethers");

const fetchAccountBalance = async () => {
  const provider = new ethers.JsonRpcProvider(
    "https://ethereum.publicnode.com"
  );

  const balance = await provider.getBalance(
    "0xe2172F74578b63E3AaA1F491C79aA09F3d2E58CF"
  );
  const blockNumber = await provider.getBlockNumber();
  const resolver = await provider.getFeeData();
  console.log({ resolver });
};

fetchAccountBalance();

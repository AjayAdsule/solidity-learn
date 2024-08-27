const ether = require("ethers");
const abi = require("./abi");

const readContract = async () => {
  const contractAddress = "0x5786323ebfbc8F2601F39f7fA12d52556fD3dFdc";
  const rpcUrl = "https://ethereum-sepolia-rpc.publicnode.com";
  const provider = new ether.JsonRpcProvider(rpcUrl);
  const contractInstance = new ether.Contract(contractAddress, abi, provider);
  const getValue = await contractInstance.getValue();
  console.log(getValue);
};
readContract();

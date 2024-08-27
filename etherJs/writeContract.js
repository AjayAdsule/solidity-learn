const ethers = require("ethers");
const updatedABi = require("./updatedAbi.json");

require("dotenv").config();
const writeOperationOnContract = async () => {
  try {
    const contractAddress = "0x5786323ebfbc8F2601F39f7fA12d52556fD3dFdc";
    const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
    const wallet = new ethers.Wallet(process.env.SECRET, provider);
    const contract = new ethers.Contract(contractAddress, updatedABi, wallet);
    const transact = await contract.setValue(100);
    await transact.wait();
    console.log({ transact });
  } catch (error) {
    throw new Error(error);
  }
};

writeOperationOnContract();

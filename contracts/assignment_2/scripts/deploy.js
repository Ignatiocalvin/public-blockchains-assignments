// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const questions = [
                    "Is deep sea gigantism caused by more concentrated oxygen levels?", 
                    "Do clouds weigh alot?",
                    "Is water wet?",
                    "Jellyfish have no brain and heart.",
                    "Is anime goated?"
  ] 
  const answers = [true, true, false, true, true];


  // questions and answers are lists of strings and booleans respectively. print each question and answer in the console.
  console.log("Deploying MyQuiz with the following questions and answers:");

  for (let i = 0; i < questions.length; i++) {
    console.log(`Question: ${questions[i]}`);
    console.log(`Answer: ${answers[i]}`);
  }
  
  const lock = await hre.ethers.deployContract("MyQuiz", [questions, answers]);
  await lock.waitForDeployment();
  console.log(`MyQuiz deployed to: ${lock.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

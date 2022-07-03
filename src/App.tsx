import React, { useState } from 'react';
import './App.css';

import Connect from './Components/Connect';
import Profile from './Components/Profile';
import GiveReaction from './Components/GiveReaction';


import Web3 from 'web3';
const web3 = new Web3(window.ethereum);
const CONTRACT_ADDRESS = "0xe76E6B1D2cA174dA6624921028cF5e3a99fDD9B9";
const CONTRACT_ABI = require('./Components/CONTRACT_ABI.json');
const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);

const App = () => {

  const [account, setAccount] = useState('');
  

  return (
    <div className="app">
      <Connect account={account} setAccount={setAccount} web3={web3} />
      {
        account !== ''
          ? <Profile account={account} />
          : <></>
      }
      <GiveReaction account={account} contract={contract} web3={web3} />
    </div>
  );
}

export default App;

import React, { useState } from 'react';
import './App.css';

import Connect from './Components/Connect';
import GiveReaction from './Components/GiveReaction';

import Web3 from 'web3';
const provider = "https://rpc.l16.lukso.network";
const web3 = new Web3(window.ethereum);

const App = () => {

  const [account, setAccount] = useState('')

  return (
    <div className="app">
      <Connect account={account} setAccount={setAccount} />
      <GiveReaction account={account} />
    </div>
  );
}

export default App;

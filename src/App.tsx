import { useState } from 'react';
import './App.css';

import { users } from './Components/Users';

import Connect from './Components/Connect';
import Profile from './Components/Profile';
//import GiveReaction from './Components/GiveReaction';
import SendPills from './Components/SendPills';


import Web3 from 'web3';
const web3 = new Web3(window.ethereum);
const CONTRACT_ABI = require('./Components/CONTRACT_ABI.json');
const CONTRACT_ADDRESS = "0x4Edbbbdd666D40b04AEf59014bf19515117cA546";
const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);

const PILL_ABI = require('./Components/PILL_ABI.json');
const PINKPILL_ADDRESS = "0xFc90EdED74008500638c777dC3C3b41A3963Ba0e";
const pinkPill = new web3.eth.Contract(PILL_ABI, PINKPILL_ADDRESS);
const GREENPILL_ADDRESS = "0xbBcf7E4Cb570E042BD384711642AB01ED4B17039";
const greenPill = new web3.eth.Contract(PILL_ABI, GREENPILL_ADDRESS);

const App = () => {

  const [account, setAccount] = useState('');
  const [pills, setPills] = useState({
    pink: -1,
    green: -1
  });

  return (
    <div className="app">
      <Connect account={account} setAccount={setAccount} web3={web3} />
      {
        account !== ''
          ? <>
              <>
              {
                users.map((element) => {
                  if(element.address === account) {
                    return <Profile connectedAccount={account} selectedAccount={element.address} contract={contract} web3={web3} />;
                  }
                  return <></>;
                })
              }
              </>

              <>
              {
                users.map((element) => {
                  if(element.address !== account) {
                    return <Profile connectedAccount={account} selectedAccount={element.address} contract={contract} web3={web3} key={element.id} />;
                  }
                  return <></>;
                })
              }
              </>
              <SendPills account={account} pinkPill={pinkPill} greenPill={greenPill} pills={pills} setPills={setPills} />
              {/*<GiveReaction account={account} contract={contract} web3={web3} />*/}
            </>
          : <></>
      }
    </div>
  );
}

export default App;

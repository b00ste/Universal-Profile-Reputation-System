import { useState, useEffect } from "react";
import "./Profile.css";

// Import and Network Setup
const Web3 = require('web3');
const { ERC725 } = require('@erc725/erc725.js');
require('isomorphic-fetch');

// Our static variables
const RPC_ENDPOINT = 'https://rpc.l16.lukso.network';
const IPFS_GATEWAY = 'https://2eff.lukso.dev/ipfs/';

// Parameters for ERC725 Instance
const erc725schema = require('@erc725/erc725.js/schemas/LSP3UniversalProfileMetadata.json');
const provider = new Web3.providers.HttpProvider(RPC_ENDPOINT);
const config = { ipfsGateway: IPFS_GATEWAY };

const Profile = ({ account, contract }:ProfileParams) => {

  const [reactions, setReactions] = useState({
    updated: false,
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0
  })

  useEffect(() => {
        
    async function fetchProfile(address: string) {
      try {
        const profile = new ERC725(erc725schema, address, provider, config);
        return await profile.fetchData();
      } catch (error) {
          return console.log('This is not an ERC725 Contract');
      }
    }

    async function fetchProfileData(address: string) {
      try {
        const profile = new ERC725(erc725schema, address, provider, config);
        return await profile.fetchData('LSP3Profile');
      } catch (error) {
          return console.log('This is not an ERC725 Contract');
      }
    }

    const getReactions = async () => {
      const newReactions = {
        updated: true,
        0: await contract.methods.getNumberOfReactionsRecieved(account, 0).call({ from: account }),
        1: await contract.methods.getNumberOfReactionsRecieved(account, 1).call({ from: account }),
        2: await contract.methods.getNumberOfReactionsRecieved(account, 2).call({ from: account }),
        3: await contract.methods.getNumberOfReactionsRecieved(account, 3).call({ from: account }),
        4: await contract.methods.getNumberOfReactionsRecieved(account, 4).call({ from: account })
      };
      setReactions(newReactions);
    }

    if (!reactions.updated) {
      getReactions();
    }

    // Step 1
    /*fetchProfile(account).then((profileData) =>
      console.log(JSON.stringify(profileData, undefined, 2)),
    );
    
    // Step 2
    fetchProfileData(account).then((profileData) =>
      console.log(JSON.stringify(profileData, undefined, 2)),
    );*/

  });

  return (
    <div className='profile'>
      <p className='profile-name' onClick={() => window.open(('https://explorer.execution.l16.lukso.network/address/' + account + '/'), '_blank', 'noopener,noreferrer')}>profile-name</p>

      <div className='profile-emoji-list'>
        <p className='profile-emoji'>{reactions[0] + 'x'} 😡</p>
        <p className='profile-emoji'>{reactions[1] + 'x'} 👎</p>
        <p className='profile-emoji'>{reactions[2] + 'x'} 👍</p>
        <p className='profile-emoji'>{reactions[3] + 'x'} 👏</p>
        <p className='profile-emoji'>{reactions[4] + 'x'} 💚</p>
      </div>
    </div>
  );
}

export default Profile;
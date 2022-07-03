import { useEffect } from "react";
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

const Profile = ({ account }:ProfileParams) => {

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
    
    // Step 1
    fetchProfile(account).then((profileData) =>
      console.log(JSON.stringify(profileData, undefined, 2)),
    );
    
    // Step 2
    fetchProfileData(account).then((profileData) =>
      console.log(JSON.stringify(profileData, undefined, 2)),
    );

  });

  return (
    <div className='profile'>
    
    </div>
  )
}

export default Profile;
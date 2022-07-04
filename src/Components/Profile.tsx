import { useState, useEffect } from "react";
import "./Profile.css";

import { users } from "./Users";

const Profile = ({ connectedAccount, selectedAccount, contract, web3 }:ProfileParams) => {

  const [emojiSelected, setEmojiSelected] = useState(-1);
  const [reactions, setReactions] = useState({
    updated: false,
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0
  })

  const selectEmoji = (index:number) => {
    if(index === emojiSelected) {
      setEmojiSelected(-1);
    }
    else if (index >= 0 && index <= 4) {
      setEmojiSelected(index);
    }
    else {
      return 0;
    }
  }

  const sendReaction = async () => {
    const res = await contract.methods.react(connectedAccount, selectedAccount, emojiSelected).send({ from: connectedAccount });
    console.log(res);
  }

  useEffect(() => {

    const getReactions = async () => {
      const newReactions = {
        updated: true,
        0: await contract.methods.getNumberOfReactionsRecieved(selectedAccount, 0).call({ from: selectedAccount }),
        1: await contract.methods.getNumberOfReactionsRecieved(selectedAccount, 1).call({ from: selectedAccount }),
        2: await contract.methods.getNumberOfReactionsRecieved(selectedAccount, 2).call({ from: selectedAccount }),
        3: await contract.methods.getNumberOfReactionsRecieved(selectedAccount, 3).call({ from: selectedAccount }),
        4: await contract.methods.getNumberOfReactionsRecieved(selectedAccount, 4).call({ from: selectedAccount })
      };
      setReactions(newReactions);
    }

    if (!reactions.updated) {
      getReactions();
    }

  });

  return (
    <div className='profile'>
      <p
        className='profile-name'
        onClick={() => window.open(('https://explorer.execution.l16.lukso.network/address/' + connectedAccount + '/'), '_blank', 'noopener,noreferrer')}
      >
        {
          users.map((element) => {
            if (element.address === selectedAccount) {
              return element.name;
            }
            return '';
          })
        }
      </p>
      {
        selectedAccount !== connectedAccount && emojiSelected !== -1
        ? <>
            <p className='react-btn' onClick={() => sendReaction()}>react</p>
            <p className='back-btn' onClick={() => setEmojiSelected(-1)}>back</p>
          </>
        : <></>
      }

        {
          connectedAccount === selectedAccount
          ? <div className='profile-emoji-list'>
              <p className='profile-emoji'>{reactions[0] + 'x'} 😡</p>
              <p className='profile-emoji'>{reactions[1] + 'x'} 👎</p>
              <p className='profile-emoji'>{reactions[2] + 'x'} 👍</p>
              <p className='profile-emoji'>{reactions[3] + 'x'} 👏</p>
              <p className='profile-emoji'>{reactions[4] + 'x'} 💚</p>
            </div>
          : <div className='profile-emoji-list'>
              <p className='profile-emoji' >
                {reactions[0] + 'x'}
                <span className='emoji' style={emojiSelected === 0 ? { opacity: '1' } : {} } onClick={() => selectEmoji(0)}>😡</span>
              </p>
              <p className='profile-emoji' >
                {reactions[1] + 'x'}
                <span className='emoji' style={emojiSelected === 1 ? { opacity: '1' } : {} } onClick={() => selectEmoji(1)}>👎</span>
              </p>
              <p className='profile-emoji' >
                {reactions[2] + 'x'}
                <span className='emoji' style={emojiSelected === 2 ? { opacity: '1' } : {} } onClick={() => selectEmoji(2)}>👍</span>
              </p>
              <p className='profile-emoji' >
                {reactions[3] + 'x'}
                <span className='emoji' style={emojiSelected === 3 ? { opacity: '1' } : {} } onClick={() => selectEmoji(3)}>👏</span>
              </p>
              <p className='profile-emoji' >
                {reactions[4] + 'x'}
                <span className='emoji' style={emojiSelected === 4 ? { opacity: '1' } : {} } onClick={() => selectEmoji(4)}>💚</span>
              </p>
            </div>
        }
      
    </div>
  );
}

export default Profile;
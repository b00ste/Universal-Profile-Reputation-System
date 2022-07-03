import { useState } from "react";
import "./GiveReaction.css";

const GiveReaction = ({ account, contract, web3 }:GiveReactionProps) => {

  const [emojiSelected, setEmojiSelected] = useState(-1);
  const [reciever, setReciever] = useState('');

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

  const saveAddress = (address: string) => {
    setReciever(address);
  }

  const sendReaction = async () => {
    if (emojiSelected === -1) {
      alert("Please select a reaction.")
      return 0;
    }
    if (!web3.utils.isAddress(reciever)) {
      alert("Please type a valid address.");
      return 0;
    }
    const res = await contract.methods.react(account, reciever, emojiSelected).send({ from: account });
    console.log(res);
  }
  const getReactions = async () => {
    if (emojiSelected === -1) {
      alert("Please select a reaction.")
      return 0;
    }
    if (!web3.utils.isAddress(reciever)) {
      alert("Please type a valid address.");
      return 0;
    }
    const res = await contract.methods.getNumberOfSymbolsRecieved(reciever, emojiSelected).call();
    console.log(res);
    alert(res);
  }

  return (
    <div className='reaction'>
      <div className='reaction-form'>
        <input onChange={(e) => saveAddress(e.target.value)} type='text' className='reaction-input' placeholder='Universal Profile Address' />
        <div>
          <button className='reaction-btn give' onClick={() => sendReaction()}>react</button>
          <button className='reaction-btn get' onClick={() => getReactions()}>see reactions</button>
        </div>
      </div>
      <div className='emoji-list' style={{ display: 'flex', flexDirection: 'row' }}>
        <p className='emoji' style={emojiSelected === 0 ? { opacity: '1' } : {} } onClick={() => selectEmoji(0)} >😡</p>
        <p className='emoji' style={emojiSelected === 1 ? { opacity: '1' } : {} } onClick={() => selectEmoji(1)} >👎</p>
        <p className='emoji' style={emojiSelected === 2 ? { opacity: '1' } : {} } onClick={() => selectEmoji(2)} >👍</p>
        <p className='emoji' style={emojiSelected === 3 ? { opacity: '1' } : {} } onClick={() => selectEmoji(3)} >👏</p>
        <p className='emoji' style={emojiSelected === 4 ? { opacity: '1' } : {} } onClick={() => selectEmoji(4)} >💚</p>
      </div>
    </div>
  );
}

export default GiveReaction;
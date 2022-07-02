import { useState } from "react";
import "./GiveReaction.css";

const GiveReaction = ({ account }:GiveReactionProps) => {

  const [emojiSelected, setEmojiSelected] = useState(-1);

  const selectEmoji = (index:number) => {
    if (index >= 0 && index <= 4) {
      setEmojiSelected(index);
    }
    else {
      return 0;
    }
  }

  return (
    <div className='give-reaction'>
      <input type='text' className='give-reaction-input' placeholder='Universal Profile Address' />
      <div className='emoji-list' style={{ display: 'flex', flexDirection: 'row' }}>
        <p className='emoji' style={emojiSelected === 0 ? { opacity: '1' } : {} } onClick={() => selectEmoji(1)} >👎</p>
        <p className='emoji' style={emojiSelected === 1 ? { opacity: '1' } : {} } onClick={() => selectEmoji(2)} >👍</p>
        <p className='emoji' style={emojiSelected === 2 ? { opacity: '1' } : {} } onClick={() => selectEmoji(0)} >😡</p>
        <p className='emoji' style={emojiSelected === 3 ? { opacity: '1' } : {} } onClick={() => selectEmoji(3)} >👏</p>
        <p className='emoji' style={emojiSelected === 4 ? { opacity: '1' } : {} } onClick={() => selectEmoji(4)} >💚</p>
      </div>
    </div>
  );
}

export default GiveReaction;
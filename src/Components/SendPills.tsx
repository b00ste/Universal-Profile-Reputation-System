import { useState, useEffect } from "react";
import "./SendPills.css";
import { ReactComponent as Pill } from './pill.svg'

const SendPills = ({ account, pinkPill, greenPill, pills, setPills }:SendPillsProps) => {

  const [pinkPillData, setPinkPillData] = useState({
    reciever: '',
    amount: 0
  });
  const [greenPillData, setGreenPillData] = useState({
    reciever: '',
    amount: 0
  });

  const setPinkPillReciever = (reciever:string) => {
    setPinkPillData({ ...pinkPillData, reciever });
  }
  const setPinkPillNumber = (amount:number) => {
    setPinkPillData({ ...pinkPillData, amount });
  }
  const sendPinkPills = async () => {
    const res = await pinkPill.methods.transfer(
      account,
      pinkPillData.reciever,
      pinkPillData.amount,
      true,
      "0x00"
    ).send({ from: account });
    console.log(res);
  }

  const setGreenPillReciever = (reciever:string) => {
    setGreenPillData({ ...greenPillData, reciever });
  }
  const setGreenPillNumber = (amount:number) => {
    setGreenPillData({ ...greenPillData, amount });
  }
  const sendGreenPills = async () => {
    const res = await greenPill.methods.transfer(
      account,
      greenPillData.reciever,
      greenPillData.amount,
      true,
      "0x00"
    ).send({ from: account });
    console.log(res);
  }

  useEffect(() => {
    
    const getNumberOfPinkPills = async () => {
      const pink = await pinkPill.methods.balanceOf(account).call({ from: account });
      setPills({ ...pills, pink });
    }
    
    const getNumberOfGreenPills = async () => {
      const green = await pinkPill.methods.balanceOf(account).call({ from: account });
      setPills({ ...pills, green });
    }

    if(pills.pink === -1) {
      getNumberOfPinkPills();
    }

    if(pills.green === -1) {
      getNumberOfGreenPills();
    }

  }, [account, pills, pinkPill.methods, setPills])
  

  return (
    <div className='send-pills'>
      <div className='pink-pill-form'>
        <input onChange={(e) => setPinkPillReciever(e.target.value)} className='address-input' type='text' placeholder='Universal Profile Address' />
        <input onChange={(e) => setPinkPillNumber(Number(e.target.value))} className='number-of-pills-input' type='number' placeholder='Pills' />
        <button onClick={() => sendPinkPills()} className='send-pills-btn'>Send</button>
        <p className='owned-pink-pills'>{pills.pink}x</p>
        <Pill className='pink-pill' />
      </div>
      <div className='green-pill-form'>
        <input onChange={(e) => setGreenPillReciever(e.target.value)} className='address-input' type='text' placeholder='Universal Profile Address' />
        <input onChange={(e) => setGreenPillNumber(Number(e.target.value))} className='number-of-pills-input' type='number' placeholder='Pills' />
        <button onClick={() => sendGreenPills()} className='send-pills-btn'>Send</button>
        <p className='owned-green-pills'>{pills.green}x</p>
        <Pill className='green-pill' />
      </div>
    </div>
  );
}

export default SendPills;
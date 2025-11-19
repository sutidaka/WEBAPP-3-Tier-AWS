import { useEffect, useState } from 'react';
import { getBalance } from '../api';

function Wallet() {
  const [balance, setBalance] = useState(null);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) return;

    getBalance(token).then(res => {
      if (res.balance !== undefined) {
        setBalance(res.balance);
      } else {
        alert('Unauthorized');
      }
    });
  }, []);

  return (
    <div>
      <h2>Wallet</h2>
      <p>Balance: {balance !== null ? `${balance} THB` : 'Loading...'}</p>
    </div>
  );
}

export default Wallet;

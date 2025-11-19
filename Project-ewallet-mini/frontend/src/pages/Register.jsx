import { useState } from 'react';
import { register } from '../api';
import { useNavigate, Link } from 'react-router-dom';

function Register() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const result = await register(username, password);
    if (result.username) {
      alert('Register success');
      navigate('/');
    } else {
      alert('Register failed');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Register</h2>
      <input value={username} onChange={e => setUsername(e.target.value)} placeholder="Username" required />
      <input value={password} onChange={e => setPassword(e.target.value)} type="password" placeholder="Password" required />
      <button type="submit">Register</button>
      <p><Link to="/">Login</Link></p>
    </form>
  );
}

export default Register;

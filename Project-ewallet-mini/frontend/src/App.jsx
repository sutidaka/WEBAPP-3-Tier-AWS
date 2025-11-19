<<<<<<< HEAD
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Login from './pages/Login';
import Register from './pages/Register';
import Wallet from './pages/Wallet';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/wallet" element={<Wallet />} />
      </Routes>
    </BrowserRouter>
=======
import { Link } from "react-router-dom";

function App() {
  return (
    <div style={{ padding: 20 }}>
      <h1>Mini Wallet Frontend</h1>
      <Link to="/login">Go to Login</Link>
    </div>
>>>>>>> 4f4d92a (Add project-ewallet-mini as normal folder)
  );
}

export default App;

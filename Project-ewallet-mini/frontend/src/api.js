<<<<<<< HEAD
const API = import.meta.env.VITE_API_URL;

export const login = async (username, password) => {
  const res = await fetch(`${API}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password })
  });
  return res.json();
};

export const register = async (username, password) => {
  const res = await fetch(`${API}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password })
  });
  return res.json();
};

export const getBalance = async (token) => {
  const res = await fetch(`${API}/wallet/balance`, {
    headers: { 'Authorization': `Bearer ${token}` }
  });
  return res.json();
};
=======
import axios from "axios";

const api = axios.create({
  baseURL: "http://127.0.0.1:8000",
});

export default api;
>>>>>>> 4f4d92a (Add project-ewallet-mini as normal folder)

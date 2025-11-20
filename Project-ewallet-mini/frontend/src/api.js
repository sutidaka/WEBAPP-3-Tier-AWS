import axios from "axios";

const API_URL = "http://localhost:8000"; // ⭐ แก้เป็น URL backend จริงของคุณ

export async function login(username, password) {
  try {
    const res = await axios.post(`${API_URL}/auth/login`, {
      username,
      password,
    });
    return res.data;
  } catch (err) {
    return {};
  }
}

export async function register(username, password) {
  try {
    const res = await axios.post(`${API_URL}/auth/register`, {
      username,
      password,
    });
    return res.data;
  } catch (err) {
    return {};
  }
}

export async function getBalance(token) {
  try {
    const res = await axios.get(`${API_URL}/wallet/balance`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    return res.data;
  } catch (err) {
    return {};
  }
}

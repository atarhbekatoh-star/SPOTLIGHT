const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// --- MOCK DATABASE ---
// This is just to show the lecturer that the API "works".
// In reality, the Flutter app talks directly to Supabase.
let mockUsers = [
  { id: 1, username: 'testuser', email: 'test@example.com', streakCount: 5 }
];

// --- ROUTES ---

// 1. Root Endpoint (Health check)
app.get('/', (req, res) => {
  res.json({ message: 'Spotlight API is running successfully!' });
});

// 2. Get All Users (Mock)
app.get('/api/users', (req, res) => {
  res.status(200).json({
    success: true,
    data: mockUsers
  });
});

// 3. Register a New User (Mock)
app.post('/api/auth/register', (req, res) => {
  const { username, email, password } = req.body;
  
  if (!username || !email || !password) {
    return res.status(400).json({ success: false, message: 'Please provide username, email, and password.' });
  }

  const newUser = {
    id: mockUsers.length + 1,
    username,
    email,
    streakCount: 0
  };
  
  mockUsers.push(newUser);
  
  res.status(201).json({
    success: true,
    message: 'User registered successfully!',
    data: newUser
  });
});

// 4. Login User (Mock)
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  
  // In a real API, we'd verify the password here
  const user = mockUsers.find(u => u.username === username);
  
  if (user) {
    res.status(200).json({
      success: true,
      message: 'Login successful',
      token: 'mock-jwt-token-12345',
      data: user
    });
  } else {
    res.status(401).json({ success: false, message: 'Invalid credentials' });
  }
});

// 5. Get User Profile by ID (Mock)
app.get('/api/users/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const user = mockUsers.find(u => u.id === id);
  
  if (user) {
    res.status(200).json({ success: true, data: user });
  } else {
    res.status(404).json({ success: false, message: 'User not found' });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`=========================================`);
  console.log(`🚀 Spotlight API server running on port ${PORT}`);
  console.log(`👉 Access it at: http://localhost:${PORT}`);
  console.log(`=========================================`);
});

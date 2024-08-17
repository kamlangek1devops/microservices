const express = require('express');
const connection = require('./config/db');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Basic route to test the API
app.get('/', (req, res) => {
    res.send('This is api1 version test');
});

// Read all records
app.get('/users', async (req, res) => {
    try {
      const [rows] = await connection.query('SELECT * FROM users');
      res.json(rows);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });


app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

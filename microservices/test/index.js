const express = require('express');
const mysql = require('mysql2');

const app = express();
const port = 3000;

// Database connection configuration
// const db = mysql.createConnection({
//     host: process.env.DB_HOST,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASS,
//     database: process.env.DB_NAME
// });

// Connect to MySQL database
// db.connect((err) => {
//     if (err) {
//         console.error('Error connecting to MySQL:', err);
//         process.exit(1);
//     }
//     console.log('Connected to MySQL database');
// });

// Basic route to test the API
app.get('/', (req, res) => {
    console.log('Host: '|| Env.DB_HOST);
    res.send('Hello, World!: '|| process.env.DB_HOST);
});


// Route to test database connection
// app.get('/users', (req, res) => {
//     db.query('SELECT * FROM users', (err, results) => {
//         if (err) {
//             res.status(500).send('Error querying database');
//         } else {
//             res.json(results);
//         }
//     });
// });

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});

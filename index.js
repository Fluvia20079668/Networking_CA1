// Import the express module
const express = require('express');

// Create an Express app
const app = express();

// Define a route for the home page
app.get('/', (req, res) => {
  res.send('welcome!');
});

// Start the server on port 3000
const PORT = 8090;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

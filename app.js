/**
 * --------------------------------------------------------------------------
 * app.js
 *
 * Minimal Express.js application to support CI/CD pipeline testing and 
 * Azure App Service deployment using Terraform and GitHub Actions.
 *
 * Endpoints:
 *  - GET /          : Returns a welcome message
 *  - GET /health    : Simple health check endpoint
 *  - GET /version   : Returns app version (uses VERSION env var or defaults to 1.0.0)
 *
 * Author: Rajesh Aradhye
 * --------------------------------------------------------------------------
 */
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Hello from Rajesh Aradhye\'s Project 🚀');
});

app.get('/health', (req, res) => {
    res.send('OK');
});

app.get('/version', (req, res) => {
    res.send(`Version: ${process.env.VERSION || '1.0.0'}`);
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`App running on port ${port}`);
});
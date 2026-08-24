import express from "express";
import os from "os";

const app = express();

const PORT = process.env.PORT || 8080;
const APP_NAME = process.env.APP_NAME || "Micro Deploy";

app.use(express.json());

app.get("/", (req, res) => {
    res.status(200).json({
        application: APP_NAME,
        message: "Hello from NodeJS running on ECS Fargate!",
        hostname: os.hostname(),
        timestamp: new Date().toISOString()
    });
});

app.get("/health", (req, res) => {
    res.status(200).json({
        status: "UP"
    });
});

app.get("/ready", (req, res) => {
    res.status(200).json({
        status: "READY"
    });
});

app.listen(PORT, () => {
    console.log(`${APP_NAME} started on port ${PORT}`);
});
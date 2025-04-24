# Flask IP and Timestamp Application

📘 README: Flask IP and Timestamp Application

---

📄 Overview

This Flask application returns the client's IP address and the current UTC timestamp in JSON format. It is containerized using Docker for ease of deployment and scalability.

---

🛠️ Prerequisites

🔹 Local Environment:
   - Docker installed on your system.
   - Internet connectivity to pull base images and dependencies.

🔹 AWS EC2 Instance:
   - An active AWS account.
   - EC2 instance running a Linux-based OS (e.g., Ubuntu).
   - Security group configured to allow inbound traffic on port 5000.
   - SSH access to the EC2 instance.

---

📁 Project Structure

project-directory/
├── app.py
├── requirements.txt
├── Dockerfile
└── README.txt

---

🐳 Dockerization

🔸 Building the Docker Image:
   Execute the following command in the project directory:

   docker build -t knikhil999/simpletimeservice .

🔸 Running the Docker Container:
   Run the container in detached mode and map port 5000:

   docker run -d -p 5000:5000 knikhil999/simpletimeservice

---

🌐 Accessing the Application

🔹 Local Access:
   Navigate to http://localhost:5000 in your web browser.

🔹 Remote Access (EC2):
   Navigate to http://<EC2-Public-IP>:5000 in your web browser.

   Ensure that:
   - The EC2 instance's security group allows inbound traffic on port 5000.
   - The application is running, and the Docker container is active.

---

🚀 Deployment Instructions

🔸 Step 1: Launch EC2 Instance
   - Log in to your AWS account.
   - Launch an EC2 instance with a Linux-based OS (e.g., Ubuntu).
   - Configure the security group to allow inbound traffic on port 5000 (Custom TCP Rule).

🔸 Step 2: Install Docker on EC2
   SSH into your EC2 instance:

   ssh -i <your-key-file.pem> ubuntu@<EC2-Public-IP>

   Update the package repository:

   sudo apt update

   Install Docker:

   sudo apt install docker.io -y

   Verify Docker installation:

   docker --version

🔸 Step 3: Deploy the Flask Application
   Clone the repository:

   git clone https://github.com/KolkurNikhil/particle41-devops-challenge-simple-time-service.git
   cd particle41-devops-challenge-simple-time-service

   Build the Docker image:

   docker build -t knikhil999/simpletimeservice .

   Run the Docker container:

   docker run -d -p 5000:5000 knikhil999/simpletimeservice

---

🧪 Testing the Application

🔹 Testing Locally:
   Send a GET request to the root endpoint:

   curl http://localhost:5000

   Expected JSON Response:

   {
     "ip": "127.0.0.1",
     "timestamp": "2025-04-15T07:00:21.254951Z"
   }

🔹 Testing on EC2:
   Access the application from your browser:

   - Local: http://localhost:5000
   - Remote: http://<EC2-Public-IP>:5000

   Test with curl:

   curl http://<EC2-Public-IP>:5000

   Expected JSON Response:

   {
     "ip": "<Your EC2 Public IP>",
     "timestamp": "2025-04-15T07:00:21.254951Z"
   }

---

✅ Best Practices Followed

- 🔒 Non-root User: Application runs as a non-root user inside the container.
- 📦 Small Image: Uses python:3.11-slim to reduce image size.
- 🧩 Single Responsibility: Container runs a single process – the Flask app.
- 🌐 Port Exposure: Only required port (5000) is exposed.

---

📌 Notes

- Ensure the EC2 instance remains active and the Docker container is running.
- Application can be integrated behind a reverse proxy for production use.
- This container can be pushed and pulled using Docker Hub for CI/CD pipelines.

---

👨‍💻 Author

Nikhil Kolkur – GitHub: https://github.com/KolkurNikhil/particle41-devops-challenge-simple-time-service


# Liberty REST App

This repository contains a simple REST microservice application built with **Jakarta EE 10**, **MicroProfile 6.0**, and **JDK 21**. It is designed to run on **Open Liberty**, a lightweight, open-source Java runtime for building cloud-native applications.

This guide will walk you through setting up and running the application using **GitHub Codespaces** or your local environment.

---

## Prerequisites

Before you begin, ensure you have the following installed:

- **JDK 21** (or higher)
- **Maven** (for building the project)
- **Docker** (optional, for containerized deployment)
- **GitHub Codespaces** (optional, for cloud-based development)

---

## Getting Started

### 1. Clone the Repository

Clone this repository to your local machine or open it in GitHub Codespaces:

```bash
git clone https://github.com/ttelang/liberty-rest-app.git
cd liberty-rest-app
```

### 2. Run the Application in GitHub Codespaces

If you prefer a cloud-based development environment, you can use **GitHub Codespaces**:

1. Open the repository in GitHub Codespaces.
2. The workspace will automatically set up the environment with JDK 21 and Maven.
3. Build and run the application using the following command:

   ```bash
   mvn liberty:run
   ```
4. Once the server starts, you can access the REST API at:

```bash
   http://<hostname>:<port>/liberty-rest-app/api/hello
```
## Additional Resources

- **Video Guide**: Watch the step-by-step tutorial on how to use this repository: [YouTube Video](https://www.youtube.com/live/sY47rJm-SW4?si=6QMJP7UL0VxmoRb-)
- **Blog Post**: Learn more about running REST microservices with Jakarta EE and MicroProfile: [Medium Blog](https://medium.com/jakarta-ee/run-a-rest-microservice-in-github-codespaces-with-jdk-21-jakarta-ee-10-microprofile-6-0-d69fec8e9998)

---

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Submit a pull request with a detailed description of your changes.

---

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Built with **Open Liberty**, **Jakarta EE 10**, and **MicroProfile 6.0**.
- Inspired by the [Jakarta EE](https://jakarta.ee/) and [MicroProfile](https://microprofile.io/) communities.

---

Feel free to reach out if you have any questions or need further assistance. Happy coding! 🚀
   

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World - OpenLiberty Microservice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 2rem;
            background-color: #f8f9fa;
        }
        .header-container {
            background-color: #1d809f;
            color: white;
            padding: 2rem 0;
            border-radius: 5px;
            margin-bottom: 2rem;
        }
        .feature-box {
            background-color: white;
            padding: 1.5rem;
            border-radius: 5px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            height: 100%;
            transition: transform 0.3s ease;
        }
        .feature-box:hover {
            transform: translateY(-5px);
        }
        .feature-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #1d809f;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-container text-center">
            <h1>Hello World MicroService</h1>
            <p class="lead">A Jakarta EE 10 and MicroProfile 6.1 Application</p>
            <div class="mt-4">
                <span class="badge bg-primary">OpenLiberty</span>
                <span class="badge bg-success">Jakarta EE 10</span>
                <span class="badge bg-info">MicroProfile 6.1</span>
                <span class="badge bg-warning">Running on Port 2010</span>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-12">
                <div class="alert alert-success">
                    <strong>Success!</strong> Your OpenLiberty server is running correctly.
                </div>
            </div>
        </div>

        <div class="row mb-5">
            <div class="col-md-4 mb-4">
                <div class="feature-box">
                    <div class="feature-icon">📊</div>
                    <h3>REST APIs</h3>
                    <p>Build RESTful microservices with JAX-RS and JSON-B.</p>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        Server Information
                    </div>
                    <div class="card-body">
                        <p><strong>Context Root:</strong> /hello-world</p>
                        <p><strong>HTTP Port:</strong> 2010</p>
                        <p><strong>HTTPS Port:</strong> 2011</p>
                        <p><strong>Server Time:</strong> <%= new java.util.Date() %></p>
                    </div>
                </div>
            </div>
        </div>

        <footer class="text-center text-muted py-4">
            <p>&copy; <%= java.time.LocalDate.now().getYear() %> Hello World Microservice - Running on OpenLiberty</p>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

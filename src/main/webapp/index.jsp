<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Web App v2.0</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0d1117 0%, #0a2540 50%, #0d2137 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            color: #e0e0e0;
        }

        .card {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(99, 230, 226, 0.18);
            border-radius: 24px;
            padding: 52px 60px;
            max-width: 560px;
            width: 90%;
            text-align: center;
            box-shadow: 0 28px 72px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(99,230,226,0.06);
        }

        .badge {
            display: inline-block;
            background: linear-gradient(90deg, #00c9a7, #0095d9);
            color: #fff;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            padding: 4px 14px;
            border-radius: 20px;
            margin-bottom: 24px;
        }

        h1 {
            font-size: 2.3rem;
            font-weight: 700;
            color: #ffffff;
            line-height: 1.2;
            margin-bottom: 14px;
        }

        h1 span { color: #00c9a7; }

        .subtitle {
            font-size: 0.98rem;
            color: #8892a4;
            margin-bottom: 36px;
            line-height: 1.6;
        }

        .server-info {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(99,230,226,0.15);
            border-radius: 10px;
            padding: 10px 20px;
            font-size: 0.85rem;
            color: #a0aec0;
            margin-bottom: 36px;
        }

        .dot { width: 8px; height: 8px; border-radius: 50%; background: #00c9a7; flex-shrink: 0; }

        .form-row {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
        }

        input[type="text"] {
            flex: 1;
            padding: 12px 18px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.12);
            background: rgba(255,255,255,0.07);
            color: #fff;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input[type="text"]::placeholder { color: #4a5568; }
        input[type="text"]:focus {
            border-color: #00c9a7;
            box-shadow: 0 0 0 3px rgba(0,201,167,0.15);
        }

        .btn {
            padding: 12px 28px;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #00c9a7, #0095d9);
            color: #fff;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: opacity 0.2s, transform 0.1s;
            white-space: nowrap;
        }

        .btn:hover { opacity: 0.88; transform: translateY(-1px); }

        .stack {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
            margin-top: 8px;
        }

        .tag {
            font-size: 0.78rem;
            color: #64748b;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 6px;
            padding: 4px 10px;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="badge">v2.0 &mdash; Test Release</div>
        <h1>Welcome to <span>App v2</span></h1>
        <p class="subtitle">
            A refreshed Java web application — same stack,<br>
            new look. Powered by Maven &amp; Apache Tomcat.
        </p>

        <div class="server-info">
            <span class="dot"></span>
            Running on <%= application.getServerInfo() %>
        </div>

        <form action="hello" method="get">
            <div class="form-row">
                <input type="text" name="name" placeholder="Enter your name…" maxlength="60" autocomplete="off">
                <button type="submit" class="btn">Say Hello</button>
            </div>
        </form>

        <div class="stack">
            <span class="tag">Java 17</span>
            <span class="tag">Maven 3.9</span>
            <span class="tag">Tomcat 9</span>
            <span class="tag">Jakarta EE 10</span>
            <span class="tag">v2.0</span>
        </div>
    </div>
</body>
</html>

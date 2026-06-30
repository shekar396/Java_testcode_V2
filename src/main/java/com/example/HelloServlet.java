package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        if (name == null || name.isBlank()) {
            name = "World";
        }

        response.setContentType("text/html;charset=UTF-8");

        String safeName   = escapeHtml(name);
        String serverInfo = escapeHtml(getServletContext().getServerInfo());

        try (PrintWriter out = response.getWriter()) {
            out.println("""
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Hello, %s! — v2</title>
                    <style>
                        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
                        body {
                            min-height: 100vh;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            background: linear-gradient(135deg, #0d1117 0%%, #0a2540 50%%, #0d2137 100%%);
                            font-family: 'Segoe UI', Arial, sans-serif;
                            color: #e0e0e0;
                        }
                        .card {
                            background: rgba(255,255,255,0.04);
                            backdrop-filter: blur(16px);
                            border: 1px solid rgba(99,230,226,0.18);
                            border-radius: 24px;
                            padding: 48px 56px;
                            max-width: 520px;
                            width: 90%%;
                            text-align: center;
                            box-shadow: 0 28px 72px rgba(0,0,0,0.5);
                        }
                        .avatar {
                            width: 72px; height: 72px;
                            border-radius: 50%%;
                            background: linear-gradient(135deg, #00c9a7, #0095d9);
                            display: flex; align-items: center; justify-content: center;
                            font-size: 2rem;
                            margin: 0 auto 24px;
                        }
                        h1 { font-size: 2.4rem; font-weight: 700; color: #fff; margin-bottom: 10px; }
                        h1 span { color: #00c9a7; }
                        .subtitle { font-size: 0.9rem; color: #8892a4; margin-bottom: 32px; }
                        .server-info {
                            display: inline-flex; align-items: center; gap: 8px;
                            background: rgba(255,255,255,0.06);
                            border: 1px solid rgba(99,230,226,0.15);
                            border-radius: 10px; padding: 10px 20px;
                            font-size: 0.82rem; color: #a0aec0; margin-bottom: 32px;
                        }
                        .dot { width: 8px; height: 8px; border-radius: 50%%; background: #00c9a7; }
                        .btn {
                            padding: 12px 28px; border-radius: 10px; border: none;
                            background: linear-gradient(135deg, #00c9a7, #0095d9);
                            color: #fff; font-size: 0.95rem; font-weight: 600;
                            cursor: pointer; text-decoration: none; display: inline-block;
                            transition: opacity 0.2s, transform 0.1s;
                        }
                        .btn:hover { opacity: 0.88; transform: translateY(-1px); }
                    </style>
                </head>
                <body>
                    <div class="card">
                        <div class="avatar">👋</div>
                        <h1>Hello, <span>%s</span>!</h1>
                        <p class="subtitle">Great to see you — running on v2.0.</p>
                        <div class="server-info">
                            <span class="dot"></span> %s
                        </div>
                        <br>
                        <a href="./" class="btn">&#8592; Back Home</a>
                    </div>
                </body>
                </html>
                """.formatted(safeName, safeName, serverInfo));
        }
    }

    private String escapeHtml(String input) {
        return input
            .replace("&",  "&amp;")
            .replace("<",  "&lt;")
            .replace(">",  "&gt;")
            .replace("\"", "&quot;")
            .replace("'",  "&#x27;");
    }
}

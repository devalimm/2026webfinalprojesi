<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="tr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Girişi</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <div class="container">
                    <div class="form-container">
                        <h2 class="page-title">Admin Girişi</h2>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-error">
                                <c:out value="${errorMessage}" />
                            </div>
                        </c:if>

                        <c:if test="${not empty requestScope.error}">
                            <div class="alert alert-error">
                                <c:out value="${requestScope.error}" />
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/login" method="post">
                            <div class="form-group">
                                <label for="email">E-posta</label>
                                <input type="email" id="email" name="email" class="form-input" required />
                            </div>
                            <div class="form-group">
                                <label for="password">Şifre</label>
                                <input type="password" id="password" name="password" class="form-input" required />
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary btn-large">Giriş Yap</button>
                            </div>
                        </form>
                    </div>
                </div>
            </body>

            </html>
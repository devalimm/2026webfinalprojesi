<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Paneli - E-Ticaret</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="admin-header">
        <div class="container">
            <div class="header-content">
                <div class="header-left">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="logo">Admin Panel</a>
                </div>
                <nav class="admin-nav">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/products">Ürünler</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">Kategoriler</a>
                    <a href="${pageContext.request.contextPath}/admin/orders">Siparişler</a>
                    <a href="${pageContext.request.contextPath}/admin/users">Kullanıcılar</a>
                    <a href="${pageContext.request.contextPath}/home" target="_blank">Siteyi Gör</a>
                    <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">Çıkış</a>
                </nav>
            </div>
        </div>
    </header>

    <main class="container main-content">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">${errorMessage}</div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Ticaret Portalı</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
</head>
<body>
    <header class="main-header">
        <div class="container">
            <div class="header-content">
                <a href="${pageContext.request.contextPath}/home" class="logo">E-Ticaret</a>
                <div class="header-right">
                    <form action="${pageContext.request.contextPath}/home" method="get" class="search-form">
                        <input type="text" name="search" placeholder="Ürün ara..." value="${param.search}">
                        <button type="submit">Ara</button>
                    </form>
                    <nav class="main-nav">
                        <a href="${pageContext.request.contextPath}/home">Ana Sayfa</a>
                        <a href="${pageContext.request.contextPath}/cart">Sepet
                            <c:set var="cart" value="${sessionScope.cart}" />
                            <c:if test="${not empty cart}">
                                <c:set var="cartCount" value="0" />
                                <c:forEach var="item" items="${cart.values()}">
                                    <c:set var="cartCount" value="${cartCount + item.quantity}" />
                                </c:forEach>
                                <span class="cart-count">${cartCount}</span>
                            </c:if>
                        </a>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/my-orders">Siparişlerim</a>
                                <span class="user-name">${sessionScope.user.fullName}</span>
                                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Çıkış</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login">Giriş</a>
                                <a href="${pageContext.request.contextPath}/register">Kayıt</a>
                            </c:otherwise>
                        </c:choose>
                    </nav>
                </div>
            </div>
        </div>
    </header>

    <div class="category-bar">
        <div class="container">
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/category?id=${cat.id}" class="category-link">${cat.name}</a>
            </c:forEach>
        </div>
    </div>

    <main class="container main-content">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">${errorMessage}</div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="Kayıt Ol" scope="request" />
<jsp:include page="includes/header.jsp" />

<div class="container">
    <div class="form-container">
        <h2 class="page-title">Kayıt Ol</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <c:out value="${error}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="fullName">Ad Soyad</label>
                <input type="text" id="fullName" name="full_name" value="<c:out value='${param.full_name}'/>" required />
            </div>
            <div class="form-group">
                <label for="email">E-posta</label>
                <input type="email" id="email" name="email" value="<c:out value='${param.email}'/>" required />
            </div>
            <div class="form-group">
                <label for="password">Şifre</label>
                <input type="password" id="password" name="password" required />
            </div>
            <div class="form-group">
                <label for="phone">Telefon</label>
                <input type="text" id="phone" name="phone" value="<c:out value='${param.phone}'/>" />
            </div>
            <div class="form-group">
                <label for="address">Adres</label>
                <textarea id="address" name="address" rows="3"><c:out value="${param.address}"/></textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Kayıt Ol</button>
            </div>
        </form>

        <p class="form-footer">
            Zaten hesabınız var mı? <a href="${pageContext.request.contextPath}/login">Giriş Yapın</a>
        </p>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

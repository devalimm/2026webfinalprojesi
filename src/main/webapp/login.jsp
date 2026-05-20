<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="title" value="Giriş Yap" scope="request" />
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <div class="form-container">
                    <h2 class="page-title">Giriş Yap</h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <c:out value="${error}" />
                        </div>
                    </c:if>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-error">
                            <c:out value="${sessionScope.error}" />
                        </div>
                        <c:remove var="error" scope="session" />
                    </c:if>

                    <c:if test="${not empty param.registered}">
                        <div class="alert alert-success">
                            Kayıt başarılı! Giriş yapabilirsiniz.
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
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

                    <p class="form-link">
                        Hesabınız yok mu? <a href="${pageContext.request.contextPath}/register">Kayıt Olun</a>
                    </p>
                </div>
            </div>

            <jsp:include page="includes/footer.jsp" />
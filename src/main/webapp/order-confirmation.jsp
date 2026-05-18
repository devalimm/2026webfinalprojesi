<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="Sipariş Onayı" scope="request" />
<jsp:include page="includes/header.jsp" />

<div class="container">
    <h2 class="page-title">Sipariş Onayı</h2>

    <c:choose>
        <c:when test="${empty sessionScope.cart}">
            <div class="cart-empty">
                <p>Sepetiniz boş. Sipariş oluşturamazsınız.</p>
                <a href="${pageContext.request.contextPath}/home">Alışverişe Başla</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="order-detail-grid">
                <div class="order-info-card">
                    <h3>Teslimat Adresi</h3>
                    <p><strong><c:out value="${sessionScope.user.fullName}" /></strong></p>
                    <p><c:out value="${sessionScope.user.email}" /></p>
                    <c:if test="${not empty sessionScope.user.phone}">
                        <p><c:out value="${sessionScope.user.phone}" /></p>
                    </c:if>
                    <c:if test="${not empty sessionScope.user.address}">
                        <p><c:out value="${sessionScope.user.address}" /></p>
                    </c:if>
                </div>
                <div class="order-info-card">
                    <h3>Sipariş Özeti</h3>
                    <c:set var="total" value="0" />
                    <c:forEach var="entry" items="${sessionScope.cart}">
                        <c:set var="item" value="${entry.value}" />
                        <c:set var="subtotal" value="${item.price * item.quantity}" />
                        <c:set var="total" value="${total + subtotal}" />
                        <p><c:out value="${item.productName}" /> x ${item.quantity} = <fmt:formatNumber value="${subtotal}" type="currency" currencyCode="TRY" maxFractionDigits="2" /></p>
                    </c:forEach>
                    <p style="margin-top:12px; font-size:18px; font-weight:bold;">
                        Genel Toplam: <fmt:formatNumber value="${total}" type="currency" currencyCode="TRY" maxFractionDigits="2" />
                    </p>
                </div>
            </div>

            <div class="cart-summary" style="text-align: center;">
                <form action="${pageContext.request.contextPath}/order" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-success">Siparişi Onayla</button>
                </form>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary">Sepete Dön</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="includes/footer.jsp" />

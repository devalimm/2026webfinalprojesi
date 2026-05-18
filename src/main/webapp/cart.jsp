<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="Sepetim" scope="request" />
<jsp:include page="includes/header.jsp" />

<div class="container">
    <h2 class="page-title">Sepetim</h2>

    <c:choose>
        <c:when test="${empty sessionScope.cart}">
            <div class="cart-empty">
                <p>Sepetiniz boş.</p>
                <a href="${pageContext.request.contextPath}/home">Alışverişe Başla</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="cart-table">
                <table>
                    <thead>
                        <tr>
                            <th>Ürün</th>
                            <th>Birim Fiyat</th>
                            <th>Adet</th>
                            <th>Ara Toplam</th>
                            <th>İşlem</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="grandTotal" value="0" />
                        <c:forEach var="entry" items="${sessionScope.cart}">
                            <c:set var="item" value="${entry.value}" />
                            <c:set var="subtotal" value="${item.price * item.quantity}" />
                            <c:set var="grandTotal" value="${grandTotal + subtotal}" />
                            <tr>
                                <td>
                                    <span style="font-size:20px;">📦</span>
                                    <c:out value="${item.productName}" />
                                </td>
                                <td>
                                    <fmt:formatNumber value="${item.price}" type="currency" currencyCode="TRY" maxFractionDigits="2" />
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/cart" method="post" class="qty-form">
                                        <input type="hidden" name="action" value="update" />
                                        <input type="hidden" name="productId" value="${item.productId}" />
                                        <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.stock}" />
                                        <button type="submit" class="btn btn-sm btn-primary">Güncelle</button>
                                    </form>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${subtotal}" type="currency" currencyCode="TRY" maxFractionDigits="2" />
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="remove" />
                                        <input type="hidden" name="productId" value="${item.productId}" />
                                        <button type="submit" class="btn btn-sm btn-danger">Çıkar</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="cart-summary">
                <h3>
                    Genel Toplam: 
                    <fmt:formatNumber value="${grandTotal}" type="currency" currencyCode="TRY" maxFractionDigits="2" />
                </h3>
                <a href="${pageContext.request.contextPath}/order" class="btn btn-success">Siparişi Tamamla</a>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Alışverişe Devam Et</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="includes/footer.jsp" />

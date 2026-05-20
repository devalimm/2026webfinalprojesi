<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="title" value="Ürün Detayı" scope="request" />
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <c:choose>
                    <c:when test="${empty product}">
                        <div class="empty-state">
                            <p>Ürün bulunamadı.</p>
                            <a href="${pageContext.request.contextPath}/home" class="btn">Ana Sayfaya Dön</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="product-detail">
                            <div class="product-detail-image">
                                📦
                            </div>
                            <div class="product-detail-info">
                                <h2>
                                    <c:out value="${product.name}" />
                                </h2>
                                <p class="price">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencyCode="TRY"
                                        maxFractionDigits="2" />
                                </p>
                                <c:if test="${not empty product.categoryName}">
                                    <p class="category">
                                        <strong>Kategori:</strong>
                                        <c:out value="${product.categoryName}" />
                                    </p>
                                </c:if>
                                <p class="stock-status">
                                    <c:if test="${product.stock > 0}">
                                        <span class="stock-in">Stokta: ${product.stock} adet</span>
                                    </c:if>
                                    <c:if test="${product.stock <= 0}">
                                        <span class="stock-out">Stokta Yok</span>
                                    </c:if>
                                </p>
                                <div class="description">
                                    <p>
                                        <c:out value="${product.description}" />
                                    </p>
                                </div>
                                <div class="product-detail-actions">
                                    <c:choose>
                                        <c:when test="${product.stock > 0}">
                                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                                <input type="hidden" name="action" value="add" />
                                                <input type="hidden" name="productId" value="${product.id}" />
                                                <button type="submit" class="btn btn-success">Sepete Ekle</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-disabled" disabled>Stokta Yok</button>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Ana
                                        Sayfaya Dön</a>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <jsp:include page="includes/footer.jsp" />
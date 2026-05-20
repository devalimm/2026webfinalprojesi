<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <c:set var="title" value="Ana Sayfa" scope="request" />
                <jsp:include page="includes/header.jsp" />

                <c:choose>
                    <c:when test="${not empty search}">
                        <h2 class="page-title">Arama sonuçları: ${search}</h2>
                        <p class="search-result-count">
                            <c:out value="${totalProducts}" /> ürün bulundu
                        </p>
                    </c:when>
                    <c:otherwise>
                        <h2 class="page-title">Tüm Ürünler</h2>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${empty products}">
                        <div class="empty-state">
                            <p>Gösterilecek ürün bulunamadı.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="product-grid">
                            <c:forEach var="product" items="${products}">
                                <div class="product-card">
                                    <div class="product-card-image">📦</div>
                                    <div class="product-card-body">
                                        <h3>
                                            <c:out value="${product.name}" />
                                        </h3>
                                        <p class="product-description">
                                            <c:choose>
                                                <c:when test="${fn:length(product.description) > 80}">
                                                    <c:out value="${fn:substring(product.description, 0, 80)}" />...
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${product.description}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="product-price">
                                            <fmt:formatNumber value="${product.price}" type="currency"
                                                currencyCode="TRY" maxFractionDigits="2" />
                                        </p>
                                        <p class="product-stock">
                                            <c:if test="${product.stock > 0}">
                                                <span class="stock-in">Stokta: ${product.stock} adet</span>
                                            </c:if>
                                            <c:if test="${product.stock <= 0}">
                                                <span class="stock-out">Stokta Yok</span>
                                            </c:if>
                                        </p>
                                        <div class="product-card-actions">
                                            <a href="${pageContext.request.contextPath}/product?id=${product.id}"
                                                class="btn btn-primary btn-sm">Detay</a>
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <form action="${pageContext.request.contextPath}/cart" method="post"
                                                        class="inline-form">
                                                        <input type="hidden" name="action" value="add" />
                                                        <input type="hidden" name="productId" value="${product.id}" />
                                                        <button type="submit" class="btn btn-success btn-sm">Sepete
                                                            Ekle</button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-disabled" disabled>Stokta
                                                        Yok</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <a
                                        href="${pageContext.request.contextPath}/home?page=${currentPage - 1}<c:if test='${not empty search}'>&search=${search}</c:if>">&laquo;
                                        Önceki</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="current">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a
                                                href="${pageContext.request.contextPath}/home?page=${i}<c:if test='${not empty search}'>&search=${search}</c:if>">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a
                                        href="${pageContext.request.contextPath}/home?page=${currentPage + 1}<c:if test='${not empty search}'>&search=${search}</c:if>">Sonraki
                                        &raquo;</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>

                <jsp:include page="includes/footer.jsp" />
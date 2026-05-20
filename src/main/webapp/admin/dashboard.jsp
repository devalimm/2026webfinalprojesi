<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:include page="includes/admin-header.jsp" />

            <h2 class="page-title">Dashboard</h2>

            <div class="dashboard-grid">
                <div class="stat-card stat-primary">
                    <div class="stat-number">${totalProducts}</div>
                    <div class="stat-label">Toplam Ürün</div>
                </div>
                <div class="stat-card stat-success">
                    <div class="stat-number">${totalCategories}</div>
                    <div class="stat-label">Toplam Kategori</div>
                </div>
                <div class="stat-card stat-success">
                    <div class="stat-number">${totalUsers}</div>
                    <div class="stat-label">Toplam Kullanıcı</div>
                </div>
                <div class="stat-card stat-warning">
                    <div class="stat-number">${totalOrders}</div>
                    <div class="stat-label">Toplam Sipariş</div>
                </div>
                <div class="stat-card stat-danger">
                    <div class="stat-number">${pendingOrders}</div>
                    <div class="stat-label">Bekleyen Sipariş</div>
                </div>
            </div>

            <div class="chart-container">
                <h3>Kategori - Ürün Dağılımı</h3>
                <c:if test="${not empty categoryStats}">
                    <c:set var="maxCount" value="0" scope="page" />
                    <c:forEach var="stat" items="${categoryStats}">
                        <c:if test="${stat.productCount > maxCount}">
                            <c:set var="maxCount" value="${stat.productCount}" scope="page" />
                        </c:if>
                    </c:forEach>
                    <c:if test="${maxCount == 0}">
                        <c:set var="maxCount" value="1" scope="page" />
                    </c:if>
                    <div class="chart-bars">
                        <c:forEach var="stat" items="${categoryStats}" varStatus="vs">
                            <c:set var="ci" value="${vs.index % 5}" scope="page" />
                            <c:set var="color" value="#3498db" scope="page" />
                            <c:if test="${ci == 1}">
                                <c:set var="color" value="#2ecc71" scope="page" />
                            </c:if>
                            <c:if test="${ci == 2}">
                                <c:set var="color" value="#e74c3c" scope="page" />
                            </c:if>
                            <c:if test="${ci == 3}">
                                <c:set var="color" value="#f39c12" scope="page" />
                            </c:if>
                            <c:if test="${ci == 4}">
                                <c:set var="color" value="#9b59b6" scope="page" />
                            </c:if>
                            <div class="chart-bar-wrap">
                                <div class="chart-bar-value">${stat.productCount}</div>
                                <div class="chart-bar"
                                    style="height: ${stat.productCount * 100 / maxCount}%; background-color: ${color};">
                                </div>
                                <div class="chart-bar-label">
                                    <c:out value="${stat.name}" />
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty categoryStats}">
                    <p style="text-align: center; color: #7f8c8d; padding: 40px;">Henüz kategori verisi bulunmamaktadır.
                    </p>
                </c:if>
            </div>

            <jsp:include page="includes/admin-footer.jsp" />
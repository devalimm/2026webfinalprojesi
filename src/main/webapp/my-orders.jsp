<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="title" value="Siparişlerim" scope="request" />
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <div class="cart-empty">
                            <p>Siparişlerinizi görüntülemek için giriş yapmalısınız.</p>
                            <a href="${pageContext.request.contextPath}/login">Giriş Yap</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty param.id and not empty orderDetail}">
                                <h2 class="page-title">Sipariş Detayı #${orderDetail.id}</h2>
                                <div class="order-info-card" style="margin-bottom: 20px;">
                                    <p><strong>Tarih:</strong>
                                        <fmt:formatDate value="${orderDetail.orderDate}" pattern="dd.MM.yyyy HH:mm" />
                                    </p>
                                    <p>
                                        <strong>Durum:</strong>
                                        <c:choose>
                                            <c:when test="${orderDetail.status == 'Beklemede'}"><span
                                                    class="badge badge-beklemede">Beklemede</span></c:when>
                                            <c:when test="${orderDetail.status == 'Hazırlanıyor'}"><span
                                                    class="badge badge-hazirlaniyor">Hazırlanıyor</span></c:when>
                                            <c:when test="${orderDetail.status == 'Kargoya Verildi'}"><span
                                                    class="badge badge-kargoya-verildi">Kargoya Verildi</span></c:when>
                                            <c:when test="${orderDetail.status == 'Tamamlandı'}"><span
                                                    class="badge badge-tamamlandi">Tamamlandı</span></c:when>
                                            <c:when test="${orderDetail.status == 'İptal Edildi'}"><span
                                                    class="badge badge-iptal-edildi">İptal Edildi</span></c:when>
                                            <c:otherwise><span
                                                    class="badge badge-beklemede">${orderDetail.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p><strong>Toplam:</strong>
                                        <fmt:formatNumber value="${orderDetail.totalAmount}" type="currency"
                                            currencyCode="TRY" maxFractionDigits="2" />
                                    </p>
                                    <c:if test="${not empty orderDetail.shippingAddress}">
                                        <p><strong>Adres:</strong>
                                            <c:out value="${orderDetail.shippingAddress}" />
                                        </p>
                                    </c:if>
                                </div>
                                <c:if test="${not empty orderItems}">
                                    <div class="data-table">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Ürün</th>
                                                    <th>Birim Fiyat</th>
                                                    <th>Adet</th>
                                                    <th>Ara Toplam</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${orderItems}">
                                                    <tr>
                                                        <td>
                                                            <c:out value="${item.productName}" />
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${item.unitPrice}" type="currency"
                                                                currencyCode="TRY" maxFractionDigits="2" />
                                                        </td>
                                                        <td>${item.quantity}</td>
                                                        <td>
                                                            <fmt:formatNumber value="${item.subtotal}" type="currency"
                                                                currencyCode="TRY" maxFractionDigits="2" />
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                                <div style="margin-top: 20px;">
                                    <a href="${pageContext.request.contextPath}/my-orders"
                                        class="btn btn-secondary">Geri</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <h2 class="page-title">Siparişlerim</h2>
                                <c:choose>
                                    <c:when test="${empty orders}">
                                        <div class="cart-empty">
                                            <p>Henüz siparişiniz bulunmamaktadır.</p>
                                            <a href="${pageContext.request.contextPath}/home">Alışverişe Başla</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="order-list">
                                            <c:forEach var="order" items="${orders}">
                                                <div class="order-card">
                                                    <div class="order-card-header">
                                                        <h3>Sipariş #${order.id}</h3>
                                                        <c:choose>
                                                            <c:when test="${order.status == 'Beklemede'}"><span
                                                                    class="badge badge-beklemede">Beklemede</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'Hazırlanıyor'}"><span
                                                                    class="badge badge-hazirlaniyor">Hazırlanıyor</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'Kargoya Verildi'}"><span
                                                                    class="badge badge-kargoya-verildi">Kargoya
                                                                    Verildi</span></c:when>
                                                            <c:when test="${order.status == 'Tamamlandı'}"><span
                                                                    class="badge badge-tamamlandi">Tamamlandı</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'İptal Edildi'}"><span
                                                                    class="badge badge-iptal-edildi">İptal Edildi</span>
                                                            </c:when>
                                                            <c:otherwise><span
                                                                    class="badge badge-beklemede">${order.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="order-card-body">
                                                        <p><strong>Tarih:</strong>
                                                            <fmt:formatDate value="${order.orderDate}"
                                                                pattern="dd.MM.yyyy HH:mm" />
                                                        </p>
                                                        <p><strong>Toplam:</strong>
                                                            <fmt:formatNumber value="${order.totalAmount}"
                                                                type="currency" currencyCode="TRY"
                                                                maxFractionDigits="2" />
                                                        </p>
                                                    </div>
                                                    <div class="order-card-footer">
                                                        <a href="${pageContext.request.contextPath}/my-orders?id=${order.id}"
                                                            class="btn btn-primary btn-sm">Detay</a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>

            <jsp:include page="includes/footer.jsp" />
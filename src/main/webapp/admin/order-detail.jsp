<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:include page="includes/admin-header.jsp" />

            <h2 class="page-title">Sipariş Detayı #${order.id}</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <div class="order-detail-grid">
                <div class="order-info-card">
                    <h3>Sipariş Bilgileri</h3>
                    <p><strong>Sipariş No:</strong> #${order.id}</p>
                    <p><strong>Müşteri:</strong>
                        <c:out value="${order.userName}" />
                    </p>
                    <p><strong>Tarih:</strong>
                        <fmt:formatDate value="${order.orderDate}" pattern="dd.MM.yyyy HH:mm" />
                    </p>
                    <p>
                        <strong>Durum:</strong>
                        <c:choose>
                            <c:when test="${order.status == 'Beklemede'}"><span
                                    class="badge badge-beklemede">Beklemede</span></c:when>
                            <c:when test="${order.status == 'Hazırlanıyor'}"><span
                                    class="badge badge-hazirlaniyor">Hazırlanıyor</span></c:when>
                            <c:when test="${order.status == 'Kargoya Verildi'}"><span
                                    class="badge badge-kargoya-verildi">Kargoya Verildi</span></c:when>
                            <c:when test="${order.status == 'Tamamlandı'}"><span
                                    class="badge badge-tamamlandi">Tamamlandı</span></c:when>
                            <c:when test="${order.status == 'İptal Edildi'}"><span
                                    class="badge badge-iptal-edildi">İptal Edildi</span></c:when>
                            <c:otherwise><span class="badge">
                                    <c:out value="${order.status}" />
                                </span></c:otherwise>
                        </c:choose>
                    </p>
                    <p><strong>Toplam Tutar:</strong>
                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺"
                            maxFractionDigits="2" />
                    </p>
                </div>

                <div class="order-info-card">
                    <h3>Durum Güncelle</h3>
                    <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                        <input type="hidden" name="action" value="updateStatus" />
                        <input type="hidden" name="id" value="${order.id}" />
                        <div class="form-group">
                            <label for="status">Sipariş Durumu</label>
                            <select id="status" name="status">
                                <option value="Beklemede" ${order.status=='Beklemede' ? 'selected' : '' }>Beklemede
                                </option>
                                <option value="Hazırlanıyor" ${order.status=='Hazırlanıyor' ? 'selected' : '' }>
                                    Hazırlanıyor</option>
                                <option value="Kargoya Verildi" ${order.status=='Kargoya Verildi' ? 'selected' : '' }>
                                    Kargoya Verildi</option>
                                <option value="Tamamlandı" ${order.status=='Tamamlandı' ? 'selected' : '' }>Tamamlandı
                                </option>
                                <option value="İptal Edildi" ${order.status=='İptal Edildi' ? 'selected' : '' }>İptal
                                    Edildi</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Durumu Güncelle</button>
                    </form>
                </div>
            </div>

            <div class="order-items-table">
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
                        <c:choose>
                            <c:when test="${not empty orderItems}">
                                <c:forEach var="item" items="${orderItems}">
                                    <tr>
                                        <td>
                                            <c:out value="${item.productName}" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${item.unitPrice}" type="currency"
                                                currencySymbol="₺" maxFractionDigits="2" />
                                        </td>
                                        <td>${item.quantity}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.subtotal}" type="currency"
                                                currencySymbol="₺" maxFractionDigits="2" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" style="text-align: center; padding: 30px; color: #7f8c8d;">Ürün
                                        bulunamadı.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div style="margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">Geri Dön</a>
            </div>

            <jsp:include page="includes/admin-footer.jsp" />